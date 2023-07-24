import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/models/Delivery.dart';
import 'package:flutter_application_1/services/deliveryService.dart';
import 'package:flutter_application_1/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Future<List<Delivery>> setDeliveryList() async {
    final DeliveryList allDeliveries =
        await DeliveryService().getAllDeliveries();
    deliveries = [];
    for (Delivery o in allDeliveries.deliveries) {
      deliveries.add(o);
    }

    return deliveries;
  }

  List<Delivery> deliveries = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: setDeliveryList(),
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
                            'Delivery #',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: getProportionateScreenWidth(18),
                                color: Colors.white),
                          ),
                        ),
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
                            'Supplier',
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
                                  '#${snapshot.data[index].deliveryId}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '#${snapshot.data[index].order['orderReferenceNo']}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: getProportionateScreenWidth(16),
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  '${snapshot.data[index].supplier['storeName']}',
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
