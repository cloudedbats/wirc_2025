// import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:wirc_2025/src/core/core.dart' as core;

startCamera() async {
  await cameraCommands('start');
}

stopCamera() async {
  await cameraCommands('stop');
}

restartCamera() async {
  await cameraCommands('restart');
}

String getStreamVideoUri() {
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/preview/stream.mjpeg',
  );
  return uri.toString();
}

Future<void> recordVideo() async {
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/record-video',
  );
  await http.post(
    uri,
    headers: <String, String>{
      'accept': 'application/json',
    },
  );
}

Future<void> saveJpeg() async {
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/save-jpeg',
  );
  await http.post(
    uri,
    headers: <String, String>{
      'accept': 'application/json',
    },
  );
}

Future<void> setSaturation({double saturation = 0.0}) async {
  var queryParameters = {'saturation': saturation.toString()};
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/saturation',
    queryParameters: queryParameters,
  );
  var response = await http.post(uri);
  if (response.statusCode != 200) {
    print('ERROR');
  }
}

Future<void> setExposureTime({int exposureTime = 0}) async {
  var queryParameters = {'time_us': exposureTime.toString()};
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/exposure-time',
    queryParameters: queryParameters,
  );
  var response = await http.post(uri);
  if (response.statusCode != 200) {
    print('ERROR');
  }
}

Future<void> setAnalogueGain({double analogueGain = 0.0}) async {
  var queryParameters = {'analogue_gain': analogueGain.toString()};
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/analogue-gain',
    queryParameters: queryParameters,
  );
  var response = await http.post(uri);
  if (response.statusCode != 200) {
    print('ERROR');
  }
}

Future<void> cameraCommands(String command) async {
  var queryParameters = {'command': command};
  var settings = core.serverSettings();
  var uri = Uri(
    scheme: settings['scheme'] ?? 'http',
    host: settings['host'],
    port: settings['port'],
    path: '/cameras/command',
    queryParameters: queryParameters,
  );
  var response = await http.post(uri);
  if (response.statusCode != 200) {
    print('ERROR');
  }
}
