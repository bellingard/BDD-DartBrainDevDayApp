import 'dart:io';
import '../lib/bdd_lib.dart';

final HOST = "127.0.0.1"; // eg: localhost
final PORT = 8080;
final DATA_FILE = "data.json";

void main() {
  HttpServer.bind(HOST, PORT).then((server) {
    server.listen((HttpRequest request) {
      switch (request.method) {
        case "GET":
          handleGet(request);
          break;
        case "POST":
          handlePost(request);
          break;
        default:
          defaultHandler(request);
      }
    }, onError: printError);
    print("Listening for GET and POST on http://$HOST:$PORT");
  }, onError: printError);
}

void handleGet(HttpRequest req) {
  HttpResponse res = req.response;
  //print("${req.method}: ${req.uri.path}");
  addCorsHeaders(res);
  var file = new File(DATA_FILE);
  if (file.existsSync()) {
    res.headers.add(HttpHeaders.CONTENT_TYPE, "application/json");
    file.readAsBytes().asStream().pipe(res); // automatically close output stream
  } else {
    var err = "Could not find file: $DATA_FILE";
    //res.addString(err);
    res.close();
  }
}

void handlePost(HttpRequest req) {
  HttpResponse res = req.response;
  //print("${req.method}: ${req.uri.path}");
  addCorsHeaders(res);
  req.listen((List<int> buffer) {
    var file = new File(DATA_FILE);
    var ioSink = file.openWrite(); // save the data to the file
    ioSink.add(buffer);
    ioSink.close();
    res.add(buffer);
    res.close();
    computeTeams();
  }, onError: printError);
}

void addCorsHeaders(HttpResponse res) {
  res.headers.add("Access-Control-Allow-Origin", "*, ");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
}

void defaultHandler(HttpRequest req) {
  HttpResponse res = req.response;
  addCorsHeaders(res);
  res.statusCode = HttpStatus.NOT_FOUND;
  res.close();
}
void printError(error) => print(error);


void computeTeams() {
  var file = new File(DATA_FILE);
  if (file.existsSync()) {
    file.readAsString().then((String contents) {
      Company company = Company.fromJSON(contents);
      new Computation(company).compute();
    });
  }
}
