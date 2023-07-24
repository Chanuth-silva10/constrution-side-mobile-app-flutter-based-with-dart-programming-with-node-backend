import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/Order.dart';
import 'package:flutter_application_1/services/orderService.dart';
import 'package:flutter_application_1/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Order>> setOrderList() async {
    final OrderList allOrders = await OrderService().getAllOrders();
    orders = [];
    for (Order o in allOrders.orders) {
      orders.add(o);
    }

    return orders;
  }

  List<Order> orders = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setOrderList(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            );
          } else {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(color: kPrimaryDarkColor),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Order #',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Status',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '${snapshot.data[index].orderReferenceNo}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '${snapshot.data[index].status}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Rs.${snapshot.data[index].total}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          }
        });
  }
}
