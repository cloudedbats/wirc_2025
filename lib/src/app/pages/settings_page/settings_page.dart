import 'package:flutter/material.dart';
import '../../../core/core.dart' as core;

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
  });

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  var isRunning = true;
  double _saturationValue = 0.0;
  double _exposureTimeValue = 0.0;
  double _analogueGainValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              // flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(8),
                        children: [
                          Table(
                            // border: TableBorder.all(),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: FlexColumnWidth(),
                              2: IntrinsicColumnWidth(),
                            },
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('Saturation'),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Slider(
                                      value: _saturationValue,
                                      min: 0.0,
                                      max: 16.0,
                                      divisions: 160,
                                      label:
                                          _saturationValue.round().toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _saturationValue = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        // core.setSaturation(saturation: value); // TODO.
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _saturationValue = 0.0;
                                        });
                                        core.setSaturation(saturation: 0.0);
                                      },
                                      child: const Text('Mono'),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('Exposure'),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Slider(
                                      value: _exposureTimeValue,
                                      min: 0.0,
                                      max: 8000.0,
                                      divisions: 800,
                                      label: calcExposure(_exposureTimeValue),
                                      onChanged: (double value) {
                                        setState(() {
                                          _exposureTimeValue = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        // var intValue = value.round();
                                        // if (value > 0.0) {
                                        //   intValue =
                                        //       (1000000.0 / value).round();
                                        // }
                                        // core.setExposureTime(
                                        //     exposureTime: intValue); // TODO.
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
                              TableRow(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0),
                                    child: Text('Analogue gain'),
                                  ),
                                  TableCell(
                                    verticalAlignment:
                                        TableCellVerticalAlignment.top,
                                    child: Slider(
                                      value: _analogueGainValue,
                                      min: 0.0,
                                      max: 50.0,
                                      divisions: 50,
                                      label:
                                          _analogueGainValue.round().toString(),
                                      onChanged: (double value) {
                                        setState(() {
                                          _analogueGainValue = value;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        // core.setAnalogueGain(
                                        //     analogueGain: value); // TODO.
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _analogueGainValue = 0.0;
                                        });
                                        core.setAnalogueGain(analogueGain: 0.0);
                                      },
                                      child: const Text('Auto'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String calcExposure(value) {
    if (value < 30.0) {
      return 'Auto';
    }
    return '1/${_exposureTimeValue.round().toString()} sec';
  }
}
