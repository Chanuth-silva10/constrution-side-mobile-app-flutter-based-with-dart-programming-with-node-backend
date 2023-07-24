import 'package:flutter/material.dart';

import '../../../size_config.dart';

class InputBox extends StatelessWidget {
  const InputBox(
      {Key? key,
        required this.label,
        required this.placeholder,
        required this.controller})
      : super(key: key);

  final String label;
  final String placeholder;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(16)),
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: getProportionateScreenWidth(16)),
            ),
            Container(
              width: getProportionateScreenWidth(150),
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter here",
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }
}