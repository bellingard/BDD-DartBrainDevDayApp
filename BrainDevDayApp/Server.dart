import 'dart:io';

main() {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      Uri uri = request.uri;
      Map<String, String> params = uri.queryParameters;
      request.response.write('URI called => ${uri.toString()}');
      request.response.write('<br/><u>');
      params.forEach((p, v) => request.response.write("<li>${p} => ${v}</li>"));
      request.response.write('</u>');
      request.response.close();
    });
  });
}