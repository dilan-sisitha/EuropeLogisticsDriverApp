import 'package:dio/dio.dart';
import 'package:euex/api/responseFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  final Dio dio = Dio();

  Future<HttpResponse> post(String url,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      bool authenticated = false,
      String? token}) async {
    var httpResponse = HttpResponse();
    try {
      dio.options.connectTimeout = 30 * 1000; //30s
      dio.options.receiveTimeout = 30 * 1000; //30s
      dio.options.headers['accept'] = 'application/json';
      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      var res = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      httpResponse.statusCode = res.statusCode;
      httpResponse.data = res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        httpResponse.statusCode = e.response!.statusCode;
        httpResponse.data = e.response!.data;
      } else {
        httpResponse.data = e.message;
        httpResponse.statusCode = 400;
      }
    }
    return httpResponse;
  }

  Future<HttpResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool authenticated = false,
  }) async {
    var httpResponse = HttpResponse();
    try {
      dio.options.connectTimeout = 30 * 1000; //5s
      dio.options.receiveTimeout = 30 * 1000; //3s
      dio.options.headers['accept'] = 'application/json';
      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      var res = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      httpResponse.statusCode = res.statusCode;
      httpResponse.data = res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        httpResponse.statusCode = e.response!.statusCode;
        httpResponse.data = e.response!.data;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        httpResponse.data = e.message;
        httpResponse.statusCode = 400;
      }
    }
    return httpResponse;
  }

  Future<HttpResponse> download(
    String urlPath,
    savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    data,
    Options? options,
    bool authenticated = false,
  }) async {
    var httpResponse = HttpResponse();
    try {
      dio.options.connectTimeout = 40 * 1000; //5s
      dio.options.receiveTimeout = 40 * 1000; //3s
      dio.options.headers['accept'] = 'application/json';
      if (authenticated) {
        final prefs = await SharedPreferences.getInstance();
        final String? token = prefs.getString('auth_token');
        dio.options.headers["Authorization"] = "Bearer $token";
      }
      var res = await dio.download(urlPath, savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          deleteOnError: deleteOnError,
          lengthHeader: lengthHeader,
          data: data,
          options: options);
      httpResponse.statusCode = res.statusCode;
      httpResponse.data = res.data;
    } on DioError catch (e) {
      if (e.response != null) {
        httpResponse.statusCode = e.response!.statusCode;
        httpResponse.data = e.response!.data;
      } else {
        httpResponse.data = e.message;
        httpResponse.statusCode = 400;
      }
    }
    return httpResponse;
  }
}
