class CCartItemModel {
  CCartItemModel({
    required this.availableStockQty,
    required this.email,
    required this.itemMetrics,
    required this.pCode,
    required this.productId,
    this.pName = '',

    required this.quantity,

    this.price = 0.0,
    required this.unitBP,
  });

  int productId;
  String email, pCode, pName, itemMetrics;
  double quantity;
  double availableStockQty;
  double price;
  double unitBP;

  /// -- empty cart --
  static CCartItemModel empty() {
    return CCartItemModel(
      productId: 0,
      email: '',
      pCode: '',
      pName: '',
      itemMetrics: '',
      quantity: 0.0,
      availableStockQty: 0.0,
      price: 0.0,
      unitBP: 0.0,
    );
  }

  /// -- convert a CartItem to a JSON map --
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'email': email,
      'pCode': pCode,
      'pName': pName,
      'itemMetrics': itemMetrics,
      'quantity': quantity,
      'availableStockQty': availableStockQty,
      'price': price,
      'unitBP': unitBP,
    };
  }

  /// -- create a CartItem from a JSON map --
  factory CCartItemModel.fromJson(Map<String, dynamic> json) {
    return CCartItemModel(
      email: json['email'],
      productId: json['productId'],
      pCode: json['pCode'],
      pName: json['pName'],
      itemMetrics: json['itemMetrics'],
      quantity: json['quantity'],
      availableStockQty: json['availableStockQty'],
      price: json['price'],
      unitBP: json['unitBP'],
    );
  }
}
