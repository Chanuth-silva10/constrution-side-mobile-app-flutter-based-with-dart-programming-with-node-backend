import 'package:flutter/material.dart';
import 'package:flutter_application_1/size_config.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.center,
            child: Image.asset("assets/images/Procuro.png")),
      ],
    );
  }
}
