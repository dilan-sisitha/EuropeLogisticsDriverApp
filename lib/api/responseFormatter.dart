import 'dart:convert';

class HttpResponse<T> {
  HttpResponse({this.statusCode, this.data});

  int? statusCode;
  dynamic data;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
