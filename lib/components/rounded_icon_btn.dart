import 'package:flutter/material.dart';

import '../size_config.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn(
      {Key? key,
      required this.iconData,
      required this.press,
      required this.color})
      : super(key: key);

  final IconData iconData;
  final GestureTapCallback press;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenWidth(30),
      width: getProportionateScreenWidth(30),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        ),
        onPressed: press,
        child: Icon(
          iconData,
          color: color,
          size: 16.0,
        ),
      ),
    );
  }
}
