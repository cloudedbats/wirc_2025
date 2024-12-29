import 'package:flutter/material.dart';
import '../../../core/core.dart' as core;

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    super.key,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  var isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            child: Text('TEST 1'),
            onPressed: () {
              core.getDirectories();
            },
          ),
          ElevatedButton(
            child: Text('TEST 2'),
            onPressed: () {
              core.getFiles("/home/wurb/wirc_recordings/wirc_2024-12-28");
            },
          ),
        ],
      ),
    );
  }
}
