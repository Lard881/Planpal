import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/network/app_failure.dart';
import 'package:planpal/core/sync/sync_engine.dart';
import 'package:planpal/features/documents/data/documents_repository.dart';
import 'package:planpal/features/documents/models/document_models.dart';
import 'package:planpal/features/documents/providers/documents_providers.dart';

const _workspaceId = '11111111-1111-4111-8111-111111111111';
const _documentId = '22222222-2222-4222-8222-222222222222';
const _folderId = '44444444-4444-4444-8444-444444444444';
const _childFolderId = '55555555-5555-4555-8555-555555555555';

Map<String, dynamic> _folderJson() => {
  'id': _folderId,
  'workspace_id': _workspaceId,
  'parent_id': null,
  'name': 'Cached folder',
  'fileCount': 0,
  'created_at': '2026-01-01T12:00:00.000Z',
  'updated_at': '2026-01-02T12:00:00.000Z',
};

Map<String, dynamic> _childFolderJson() => {
  'id': _childFolderId,
  'workspace_id': _workspaceId,
  'parent_id': _folderId,
  'name': 'Nested folder',
  'fileCount': 0,
  'created_at': '2026-01-01T12:00:00.000Z',
  'updated_at': '2026-01-02T12:00:00.000Z',
};

Map<String, dynamic> _documentJson() => {
  'id': _documentId,
  'workspace_id': _workspaceId,
  'folder_id': null,
  'kind': 'written',
  'title': 'Cached note',
  'file_id': null,
  'content': {
    'ops': [
      {'insert': 'Offline content\n'},
    ],
  },
  'content_text': 'Offline content',
  'created_by': '33333333-3333-4333-8333-333333333333',
  'created_at': '2026-01-01T12:00:00.000Z',
  'updated_at': '2026-01-02T12:00:00.000Z',
};

Map<String, dynamic> _fileDocumentJson() => {
  ..._documentJson(),
  'id': '66666666-6666-4666-8666-666666666666',
  'kind': 'file',
  'title': 'Design preview.png',
  'file_id': '77777777-7777-4777-8777-777777777777',
  'content': null,
  'file': {
    'mime_type': 'image/png',
    'size_bytes': 2048,
    'storage_path': 'workspace/design-preview.png',
  },
};

void main() {
  late AppDatabase database;
  late Dio dio;
  late SyncEngine sync;
  late DocumentsRepository repository;
  var mode = 'online';
  var documents = <Map<String, dynamic>>[];
  var folders = <Map<String, dynamic>>[];
  var requestPaths = <String>[];

  setUp(() {
    mode = 'online';
    documents = [_documentJson()];
    folders = [_folderJson(), _childFolderJson()];
    requestPaths = [];
    database = AppDatabase(NativeDatabase.memory());
    dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requestPaths.add(options.path);
          if (mode == 'offline') {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionError,
              ),
            );
          } else if (mode == 'conflict') {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 409,
                  data: {
                    'error': {'code': 'FOLDER_NOT_EMPTY'},
                  },
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          } else if (mode == 'not-found') {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                  data: {
                    'error': {'code': 'NOT_FOUND'},
                  },
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          } else if (options.method == 'DELETE') {
            handler.resolve(Response(requestOptions: options, statusCode: 204));
          } else {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: options.path.endsWith('/folders')
                    ? {
                        'folders': folders
                            .where(
                              (folder) =>
                                  folder['parent_id'] ==
                                  options.queryParameters['parentId'],
                            )
                            .toList(),
                      }
                    : {
                        'documents': documents
                            .where(
                              (document) =>
                                  options.queryParameters['recent'] == 'true' ||
                                  document['folder_id'] ==
                                      options.queryParameters['folderId'],
                            )
                            .toList(),
                      },
              ),
            );
          }
        },
      ),
    );
    sync = SyncEngine(dio, database);
    repository = DocumentsRepository(dio, database, sync);
  });

  tearDown(() async {
    sync.dispose();
    await database.close();
  });

  test('successful document lists are cached with written content', () async {
    final (remote, remoteFailure) = await repository.getDocuments(_workspaceId);

    expect(remoteFailure, isNull);
    expect(remote.single.contentText, 'Offline content');

    mode = 'offline';
    final (cached, offlineFailure) = await repository.getDocuments(
      _workspaceId,
    );

    expect(offlineFailure, isNotNull);
    expect(cached.single.id, _documentId);
    expect(cached.single.contentText, 'Offline content');
    expect(cached.single.content?['ops'], isNotEmpty);
  });

  test('uploaded file metadata remains distinct from written documents', () {
    final fileDocument = DocumentModel.fromJson(_fileDocumentJson());

    expect(fileDocument.isFile, isTrue);
    expect(fileDocument.isWritten, isFalse);
    expect(fileDocument.isImage, isTrue);
    expect(fileDocument.mimeType, 'image/png');
    expect(fileDocument.sizeBytes, 2048);
  });

  test(
    'cached document detail is available without a network request',
    () async {
      await repository.getDocuments(_workspaceId);
      requestPaths.clear();

      final cached = await repository.getCachedDocument(_documentId);

      expect(cached?.id, _documentId);
      expect(requestPaths, isEmpty);
    },
  );

  test('written documents are cached and queued before remote sync', () async {
    mode = 'offline';

    final (document, failure) = await repository.createWrittenDocument(
      _workspaceId,
      'Instant draft',
    );

    expect(failure, isNull);
    expect(document, isNotNull);
    final created = document!;
    expect((await repository.getCachedDocument(created.id))?.id, created.id);
    final queued = await (database.select(
      database.outboxEntries,
    )..where((entry) => entry.entityId.equals(created.id))).getSingle();
    expect(queued.operation, 'create');
    expect(queued.entityType, 'documents');
  });

  test(
    'successful folder and document lists prune stale cached rows',
    () async {
      await repository.getFolders(_workspaceId);
      await repository.getDocuments(_workspaceId);

      folders = [];
      documents = [];
      expect((await repository.getFolders(_workspaceId)).$1, isEmpty);
      expect((await repository.getDocuments(_workspaceId)).$1, isEmpty);

      mode = 'offline';
      expect((await repository.getFolders(_workspaceId)).$1, isEmpty);
      expect((await repository.getDocuments(_workspaceId)).$1, isEmpty);
    },
  );

  test(
    'folder navigation loads nested contents and returns to its parent',
    () async {
      final notifier = DocumentsNotifier(repository, _workspaceId);
      await notifier.load();

      await notifier.openFolder(FolderModel.fromJson(_folderJson()));

      expect(notifier.state.currentFolderId, _folderId);
      expect(notifier.state.folderPath.map((folder) => folder.id), [_folderId]);
      expect(notifier.state.folders.single.id, _childFolderId);
      expect(notifier.state.recentDocs, isEmpty);

      await notifier.goUpFolder();

      expect(notifier.state.currentFolderId, isNull);
      expect(notifier.state.folderPath, isEmpty);
      expect(notifier.state.folders.single.id, _folderId);
      notifier.dispose();
    },
  );

  test('not-found detail reads remove stale cached documents', () async {
    await repository.getDocuments(_workspaceId);
    mode = 'not-found';

    final (document, failure) = await repository.getDocument(_documentId);

    expect(document, isNull);
    expect(failure, isA<NotFoundFailure>());
    final cached = await (database.select(
      database.documents,
    )..where((row) => row.id.equals(_documentId))).getSingleOrNull();
    expect(cached?.deletedAt, isNotNull);
  });

  test(
    'deleted files stay hidden when returning to the document list',
    () async {
      await repository.getDocuments(_workspaceId);

      expect(await repository.deleteDocument(_documentId), isNull);
      expect(requestPaths.last, '/documents/$_documentId');

      final reopenedScreen = DocumentsNotifier(repository, _workspaceId);
      await reopenedScreen.load();
      expect(reopenedScreen.state.recentDocs, isEmpty);
      reopenedScreen.dispose();

      mode = 'offline';
      expect((await repository.getDocuments(_workspaceId)).$1, isEmpty);
    },
  );

  test(
    'folder deletion uses the item route and stays hidden after re-entry',
    () async {
      await repository.getFolders(_workspaceId);

      expect(await repository.deleteFolder(_folderId), isNull);
      expect(requestPaths.last, '/folders/$_folderId');

      final reopenedScreen = DocumentsNotifier(repository, _workspaceId);
      await reopenedScreen.load();
      expect(reopenedScreen.state.folders, isEmpty);
      reopenedScreen.dispose();

      mode = 'offline';
      expect((await repository.getFolders(_workspaceId)).$1, isEmpty);
    },
  );

  test(
    'offline document deletion hides locally and restores on rejection',
    () async {
      await repository.getDocuments(_workspaceId);
      mode = 'offline';

      expect(await repository.deleteDocument(_documentId), isNull);
      final deleted = await (database.select(
        database.documents,
      )..where((row) => row.id.equals(_documentId))).getSingle();
      expect(deleted.deletedAt, isNotNull);

      mode = 'conflict';
      await sync.push();

      final restored = await (database.select(
        database.documents,
      )..where((row) => row.id.equals(_documentId))).getSingle();
      expect(restored.deletedAt, isNull);
    },
  );

  test(
    'offline document edits queue and restore cached values on rejection',
    () async {
      await repository.getDocuments(_workspaceId);
      mode = 'offline';

      expect(
        await repository.updateDocument(
          _documentId,
          title: 'Changed offline',
          contentText: 'Changed offline content',
        ),
        isNull,
      );
      mode = 'conflict';
      await sync.push();

      final restored = await (database.select(
        database.documents,
      )..where((row) => row.id.equals(_documentId))).getSingle();
      expect(restored.title, 'Cached note');
      expect(restored.contentText, 'Offline content');
      expect(jsonDecode(restored.content!)['ops'], isNotEmpty);
    },
  );

  test('offline folder creation queues the client-generated ID', () async {
    mode = 'offline';

    final (folder, failure) = await repository.createFolder(
      _workspaceId,
      'Offline folder',
    );

    expect(failure, isNull);
    expect(folder, isNotNull);
    final savedFolder = folder!;
    final queued = await (database.select(
      database.outboxEntries,
    )..where((row) => row.entityId.equals(savedFolder.id))).getSingle();
    final payload = jsonDecode(queued.payload) as Map<String, dynamic>;
    expect(queued.entityType, 'workspaces/$_workspaceId/folders');
    expect(payload['id'], savedFolder.id);
  });
}
