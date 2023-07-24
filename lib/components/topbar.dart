import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../size_config.dart';

class Topbar extends StatelessWidget implements PreferredSizeWidget {
  const Topbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 10,
            color: Color(0xFFDADADA).withOpacity(0.20),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            title: Image.asset("assets/images/Procuro-small.png",
                width: getProportionateScreenWidth(160)),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
                icon: SvgPicture.asset("assets/icons/hamburger.svg"),
                onPressed: () => {}),
            actions: <Widget>[
              // IconButton(
              //     icon: SvgPicture.asset("assets/icons/Search Icon 1.svg"),
              //     padding: EdgeInsets.only(left: 15),
              //     onPressed: () => {}),
              // IconButton(
              //     icon: SvgPicture.asset("assets/icons/notification.svg"),
              //     onPressed: () => {}),
            ],
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(80);
}
