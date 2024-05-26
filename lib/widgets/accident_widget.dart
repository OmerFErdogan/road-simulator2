// lib/widgets/accident_widget.dart
import 'package:flutter/material.dart';
import '../models/accident_type.dart';

class AccidentWidget extends StatelessWidget {
  final AccidentType accidentType;
  final int laneNumber;

  const AccidentWidget({
    Key? key,
    required this.accidentType,
    required this.laneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (accidentType == AccidentType.None) {
      return SizedBox.shrink();
    }

    return Positioned(
      top: 10.0,
      left:
          laneNumber == 1 ? 20.0 : MediaQuery.of(context).size.width / 2 + 20.0,
      child: Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.red,
        child: Text(
          'Şerit $laneNumber: ${getAccidentDescription(accidentType)} (SHOW TV) ',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
