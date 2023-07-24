class Order {
  static const ID = "_id";
  static const ORDERREFERENCENO = "orderReferenceNo";
  static const SITE = "site";
  static const SUPPLIER = "supplier";
  static const DELIVERYADDRESS = "deliveryAddress";
  static const EXPECTEDDELIVERYDATE = "expectedDeliveryDate";
  static const TOTAL = "total";
  static const ITEMS = "items";
  static const STATUS = "status";
  static const COMMENTS = "comments";

  final String id;
  final int orderReferenceNo;
  final Map<String, dynamic> site;
  final Map<String, dynamic> supplier;
  final String deliveryAddress;
  final String expectedDeliveryDate;
  final int total;
  final List<dynamic> items;
  final String status;
  final List<dynamic> comments;

  Order(
      {required this.id,
      required this.orderReferenceNo,
      required this.site,
      required this.supplier,
      required this.deliveryAddress,
      required this.expectedDeliveryDate,
      required this.total,
      required this.items,
      required this.status,
      required this.comments});

  factory Order.fromJson(Map<String, dynamic> json) {
    var order = Order(
      id: json[Order.ID],
      orderReferenceNo: json[Order.ORDERREFERENCENO],
      site: json[Order.SITE],
      supplier: json[Order.SUPPLIER],
      deliveryAddress: json[Order.DELIVERYADDRESS],
      expectedDeliveryDate: json[Order.EXPECTEDDELIVERYDATE],
      total: json[Order.TOTAL],
      items: json[Order.ITEMS],
      status: json[Order.STATUS],
      comments: json[Order.COMMENTS],
    );
    return order;
  }
}

class OrderList {
  final List<Order> orders;

  OrderList({required this.orders});

  factory OrderList.fromJson(List<dynamic> parsedJson) {
    List<Order> orders = <Order>[];
    orders = parsedJson.map((i) => Order.fromJson(i)).toList();
    return new OrderList(orders: orders);
  }
}
