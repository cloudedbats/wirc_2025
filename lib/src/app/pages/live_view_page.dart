import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import '../../core.dart' as core;

class LiveViewWidget extends StatefulWidget {
  const LiveViewWidget({
    super.key,
  });

  @override
  State<LiveViewWidget> createState() => _LiveViewWidgetState();
}

class _LiveViewWidgetState extends State<LiveViewWidget> {
  var isRunning = true;
  double _exposureTimeValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          // flex: 1,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Mjpeg(
                  isLive: isRunning,
                  error: (context, error, stack) {
                    print(error);
                    print(stack);
                    return Text(error.toString(),
                        style: const TextStyle(color: Colors.red));
                  },
                  stream: core.getStreamVideoUri(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 10.0,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isRunning = !isRunning;
                          });
                        },
                        child: const Text('On/off'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          core.recordVideo();
                        },
                        child: const Text('Video'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          core.saveJpeg();
                        },
                        child: const Text('Image'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const LiveViewFullScreen()),
                          );
                        },
                        child: const Text('Full screen'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      cameraSettingsTable(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Table cameraSettingsTable() {
    return Table(
      // border: TableBorder.all(),
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(4.0),
              child: Text('Exposure'),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Slider(
                value: _exposureTimeValue,
                min: 0.0,
                max: 4000.0,
                divisions: 400,
                label: calcExposure(_exposureTimeValue),
                onChanged: (double value) {
                  setState(() {
                    _exposureTimeValue = value;
                  });
                },
                onChangeEnd: (value) {
                  var intValue = value.round();
                  if (value > 0.0) {
                    intValue = (1000000.0 / value).round();
                  }
                  core.setExposureTime(exposureTime: intValue);
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _exposureTimeValue = 0.0;
                  });
                  core.setExposureTime(exposureTime: 0);
                },
                child: const Text('Auto'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String calcExposure(value) {
    if (value < 30.0) {
      return 'Auto';
    }
    return '1/${_exposureTimeValue.round().toString()} sec';
  }
}

class LiveViewFullScreen extends StatelessWidget {
  const LiveViewFullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Full screen'),
        actions: [
          Center(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    core.recordVideo();
                  },
                  child: const Text('Record video'),
                ),
                Text(" "),
                ElevatedButton(
                  onPressed: () async {
                    core.saveJpeg();
                  },
                  child: const Text('Save image'),
                ),
                Text("  "),
              ],
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Mjpeg(
          isLive: true,
          error: (context, error, stack) {
            print(error);
            print(stack);
            return Text(error.toString(),
                style: const TextStyle(color: Colors.red));
          },
          stream: core.getStreamVideoUri(),
        ),
      ),
    );
  }
}
