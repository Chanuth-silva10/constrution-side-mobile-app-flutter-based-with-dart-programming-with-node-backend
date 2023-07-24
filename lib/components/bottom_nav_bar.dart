import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/enums.dart';
import 'package:flutter_application_1/screens/all-deliveries/all-deliveries_screen.dart';
import 'package:flutter_application_1/screens/all-orders/all-order_screen.dart';
import 'package:flutter_application_1/screens/all-suppliers/all-suppliers_screen.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';

import '../constants.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    Key? key,
    required this.selectedMenu,
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    final Color inActiveIconColor = Color(0xFF8E8E8E);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Shop Icon 1.svg",
                  color: MenuState.home == selectedMenu
                      ? kPrimaryDarkColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, HomeScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/menu 1.svg",
                  color: MenuState.orders == selectedMenu
                      ? kPrimaryDarkColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AllOrderScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/shopping cart.svg",
                  color: MenuState.deliveries == selectedMenu
                      ? kPrimaryDarkColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AllDeliveriesScreen.routeName),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/user 1.svg",
                  color: MenuState.suppliers == selectedMenu
                      ? kPrimaryDarkColor
                      : inActiveIconColor,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, AllSupplierScreen.routeName),
              )
            ],
          ),
        ));
  }
}
