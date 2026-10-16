import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planpal/core/db/app_database.dart';
import 'package:planpal/core/sync/sync_engine.dart';
import 'package:planpal/features/documents/data/documents_repository.dart';

void main() {
  test('cancelled upload returns without an upload failure', () async {
    final database = AppDatabase(NativeDatabase.memory());
    final dio = Dio(BaseOptions(baseUrl: 'https://planpal.test/api/v1'));
    final sync = SyncEngine(dio, database);
    addTearDown(sync.dispose);
    addTearDown(database.close);

    final directory = await Directory.systemTemp.createTemp('planpal-upload-');
    addTearDown(() => directory.delete(recursive: true));
    final file = File('${directory.path}${Platform.pathSeparator}file.pdf');
    await file.writeAsBytes([1]);

    final cancelToken = CancelToken()..cancel();
    final (fileId, failure) = await DocumentsRepository(dio, database, sync)
        .uploadFile(
          'workspace-1',
          file,
          'application/pdf',
          cancelToken: cancelToken,
        );

    expect(fileId, isNull);
    expect(failure, isNull);
  });
}
