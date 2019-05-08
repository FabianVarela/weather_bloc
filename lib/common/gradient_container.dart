import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  final MaterialColor backgroundColor;
  final Widget child;

  GradientContainer({@required this.backgroundColor, @required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.6, 0.8, 1.0],
          colors: [
            backgroundColor[700],
            backgroundColor[500],
            backgroundColor[300],
          ],
        ),
      ),
      child: child,
    );
  }
}
