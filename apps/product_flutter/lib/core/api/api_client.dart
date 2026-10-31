import 'package:dio/dio.dart';
import 'package:scoutlink_product/core/config/app_config.dart';

Dio createApiClient(String accessToken) {
  return Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Authorization': 'Bearer $accessToken'},
    ),
  );
}
