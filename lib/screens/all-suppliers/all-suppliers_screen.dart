import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/CustomAppBar.dart';
import 'package:flutter_application_1/components/bottom_nav_bar.dart';
import 'package:flutter_application_1/screens/all-suppliers/components/body.dart';

import '../../enums.dart';

class AllSupplierScreen extends StatelessWidget {
  static String routeName = "/supplier";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "All Suppliers",
      ),
      body: Body(),
      bottomNavigationBar: BottomNavBar(selectedMenu: MenuState.suppliers),
    );
  }
}
