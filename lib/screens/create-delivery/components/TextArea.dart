import 'package:flutter/material.dart';

import '../../../size_config.dart';

class TextArea extends StatelessWidget {
  const TextArea(
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
      child: Expanded(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(16)),
              ),
              Container(
                width: double.infinity,
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: "Enter Order Notes Here",
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
