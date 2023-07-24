import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomAppBar.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/components/topbar.dart';
import 'package:flutter_application_1/screens/create-order/components/body.dart';

import '../../enums.dart';

class CreateOrderScreen extends StatelessWidget {
  static String routeName = "/order/create";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Create Order",
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
