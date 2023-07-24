class Delivery {
  static const ID = "_id";
  static const DELIVERYID = "deliveryId";
  static const DATE = "date";
  static const ORDERID = "orderId";
  static const SUPPLIERID = "supplierId";
  static const ITEMS = "items";
  static const COMMENT = "comment";

  final String id;
  final int deliveryId;
  final String date;
  final Object order;
  final Object supplier;
  final List<dynamic> items;
  final String comment;

  Delivery({
      required this.id,
      required this.deliveryId,
      required this.date,
      required this.order,
      required this.supplier,
      required this.items,
      required this.comment
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    var delivery = Delivery(
      id: json[Delivery.ID],
      deliveryId: json[Delivery.DELIVERYID],
      date: json[Delivery.DATE],
      order: json[Delivery.ORDERID],
      supplier: json[Delivery.SUPPLIERID],
      items: json[Delivery.ITEMS],
      comment: json[Delivery.COMMENT],
    );
    return delivery;
  }
}

class DeliveryList {
  final List<Delivery> deliveries;

  DeliveryList({required this.deliveries});

  factory DeliveryList.fromJson(List<dynamic> parsedJson) {
    List<Delivery> deliveries = <Delivery>[];
    deliveries = parsedJson.map((i) => Delivery.fromJson(i)).toList();
    return new DeliveryList(deliveries: deliveries);
  }
}
