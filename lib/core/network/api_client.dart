import 'package:dio/dio.dart';

import '../../constant/imports.dart';

final tkn = const FlutterSecureStorage().read(key: 'token');

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      // baseUrl: 'https://datahubsapi.prisca.5starcompany.com.ng/api',
      baseUrl: 'https://backend.optionvtu.com.ng/api',
      // connectTimeout: const Duration(seconds: 8000),
      // receiveTimeout: const Duration(seconds: 8000),
      headers: {
        'Authorization': 'Bearer $tkn',
        'Content-Type': 'application/json'
      },
    ),
  );
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.baseUrl = ApiService.dio.options.baseUrl;
    return handler.next(options);
  }
}
