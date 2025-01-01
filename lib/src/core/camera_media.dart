import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
// import 'package:wirc_2025/src/core/core.dart' as core;
import 'package:wirc_2025/src/data/data.dart' as data;

Future<void> getDirectories({String media = 'video'}) async {
  // curl -X 'GET' \
  // 'http://wurb-aa-51c:8082/directories' \
  // -H 'accept: application/json'
  var settings = data.serverSettings();
  // var queryParameters = {
  //   'media_type': media,
  // };
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/directories',
    // queryParameters: queryParameters,
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
    if (media == 'video') {
      data.addVideoDirs(decodedResponse);
    } else {
      data.addImageDirs(decodedResponse);
    }
  } else {
    throw Exception('Failed to load data from server.');
  }
}

Future<void> getFiles(String directory, {String media = 'video'}) async {
  // curl -X 'GET' \
  // 'http://wurb-aa-51c:8082/files?dir_path=%2Fhome%2Fwurb%2Fwirc_recordings%2Fwirc_2024-12-28' \
  // -H 'accept: application/json'
  var settings = data.serverSettings();
  late var dirPath = '';
  if (media == 'video') {
    dirPath = data.videoDirByName[directory]!.videoDirPath;
  } else {
    dirPath = data.imageDirByName[directory]!.imageDirPath;
  }
  var queryParameters = {
    'dir_path': Uri.encodeFull(dirPath),
    'media_type': media,
  };
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
    if (media == 'video') {
      data.addVideoFiles(decodedResponse);
    } else {
      data.addImageFiles(decodedResponse);
    }
  } else {
    throw Exception('Failed to load data from server.');
  }
}

String getFileDownloadUri(String fileName) {
  var videoFile = data.videoFileByName[fileName];
  var videoFilePath = videoFile!.videoFilePath;
  var settings = data.serverSettings();
  var queryParameters = {'file_path': videoFilePath};
//   var queryParameters = {'file_path': Uri.encodeFull(videoFilePath)};
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: 'files/download',
    queryParameters: queryParameters,
  );
  return uri.toString();
}
