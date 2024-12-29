import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

Future<void> getDirectories() async {
  // curl -X 'GET' \
  // 'http://wurb-aa-51c:8082/directories' \
  // -H 'accept: application/json'
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/directories',
  );
  final response = await http.get(
    uri,
    headers: <String, String>{
      'accept': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    data.addDirectories(decodedResponse);
  } else {
    throw Exception('Failed to load data from server.');
  }
}

Future<void> getFiles(String directory) async {
  // curl -X 'GET' \
  // 'http://wurb-aa-51c:8082/files?dir_path=%2Fhome%2Fwurb%2Fwirc_recordings%2Fwirc_2024-12-28' \
  // -H 'accept: application/json'
  var settings = core.serverSettings();
  var queryParameters = {'dir_path': Uri.encodeFull(directory)};
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/files',
    queryParameters: queryParameters,
  );
  final response = await http.get(
    uri,
    headers: <String, String>{
      'accept': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    var decodedResponse =
        convert.jsonDecode(convert.utf8.decode(response.bodyBytes)) as Map;
    data.addFiles(decodedResponse);
  } else {
    throw Exception('Failed to load data from server.');
  }
}
