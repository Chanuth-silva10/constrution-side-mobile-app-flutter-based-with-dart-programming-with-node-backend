import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/rounded_icon_btn.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height + 10);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(color: kPrimaryDarkColor),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              RoundedIconBtn(
                iconData: Icons.arrow_back_ios,
                press: () => Navigator.pop(context),
                color: Colors.black,
              ),
              Expanded(
                  child: Center(
                      child: Text(
                title,
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )))
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
