import 'package:dio/dio.dart';

class ApiClient {
  late Dio dio;
  final String baseUrl =
      "https://finance-tracker-958979735189.europe-west1.run.app";

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // You can add interceptors if needed
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Perform actions before the request is sent
        return handler.next(options); // continue with request
      },
      onResponse: (response, handler) {
        // Perform actions on data before returning the response
        return handler.next(response); // continue with response
      },
      onError: (DioException e, handler) {
        // Perform actions when an error occurs
        return handler.next(e); // continue with error
      },
    ));
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return await dio.get(endpoint, queryParameters: queryParameters);
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    return await dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    return await dio.put(endpoint, data: data);
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    return await dio.delete(endpoint, data: data);
  }
}
