// app/lib/features/home/data/home_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_error_mapper.dart';
import '../../../core/network/app_failure.dart';
import '../models/home_models.dart';

class HomeRepository {
  final Dio _dio;
  HomeRepository(this._dio);

  Future<(HomeOverview?, AppFailure?)> getOverview(
      String workspaceId, String range) async {
    try {
      final res = await _dio.get(
        '/workspaces/$workspaceId/analytics/overview',
        queryParameters: {'range': range},
      );
      return (HomeOverview.fromJson(res.data as Map<String, dynamic>), null);
    } on DioException catch (e) {
      return (null, mapDioError(e));
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(ref.watch(apiClientProvider).dio);
});
