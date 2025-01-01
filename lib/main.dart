import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'src/app/pages.dart' as app;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  app.startApp();
}
