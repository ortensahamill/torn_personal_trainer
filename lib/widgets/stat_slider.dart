import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torn_personal_trainer/models/ratio.dart';

class StatSliderWidget extends StatefulWidget {
  final double initialStatValue;
  final double maxStatValue;
  final String statName;
  const StatSliderWidget(
      {super.key,
      required this.initialStatValue,
      required this.statName,
      required this.maxStatValue});

  @override
  State<StatSliderWidget> createState() => _StatSliderWidgetState();
}

class _StatSliderWidgetState extends State<StatSliderWidget> {
  double? _currentStatValue;
  @override
  Widget build(BuildContext context) {
    return Consumer<RatioModel>(
        builder: (context, ratio, child) => Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: [Text(widget.statName)],
                    ),
                    Slider(
                      value: _currentStatValue ?? widget.initialStatValue,
                      min: widget.initialStatValue,
                      max: widget.maxStatValue,
                      divisions: (widget.maxStatValue - widget.initialStatValue)
                          .toInt(),
                      label: _currentStatValue?.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentStatValue = value;
                          switch (widget.statName) {
                            case "Dexterity":
                              ratio.setCurrentDexterity(value.toInt());
                              break;
                            case "Strength":
                              ratio.setCurrentStrength(value.toInt());
                              break;
                            case "Speed":
                              ratio.setCurrentSpeed(value.toInt());
                              break;
                            default:
                              break;
                          }
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Initial Value: ${widget.initialStatValue}"),
                        Text('Maximum Value: ${widget.maxStatValue}'),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }
}
