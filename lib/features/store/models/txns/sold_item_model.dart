import 'package:cloud_firestore/cloud_firestore.dart';

class CSoldItemModel {
  int? _soldItemId;
  int _txnId = 0;
  int _productId = 0;
  String _productCode = "";
  String _productName = "";

  String _itemMetrics = '';
  double _quantity = 0;
  double _qtyRefunded = 0;
  String _refundReason = "";
  double _unitBP = 0.0;
  double _unitSellingPrice = 0.0;
  String _userEmail = '';

  CSoldItemModel(
    this._txnId,
    this._productId,
    this._productCode,
    this._productName,
    this._itemMetrics,
    this._quantity,
    this._qtyRefunded,
    this._refundReason,
    this._unitBP,
    this._unitSellingPrice,
    this._userEmail,
  );

  CSoldItemModel.withId(
    this._soldItemId,
    this._txnId,
    this._productId,
    this._productCode,
    this._productName,
    this._itemMetrics,
    this._quantity,
    this._qtyRefunded,
    this._refundReason,
    this._unitBP,
    this._unitSellingPrice,
    this._userEmail,
  );

  static CSoldItemModel empty() {
    return CSoldItemModel(
      0,
      0,
      '',
      '',
      '',
      0.0,
      0.0,
      '',
      0.0,
      0.0,
      '',
    );
  }

  int? get soldItemId => _soldItemId;
  int get txnId => _txnId;
  int get productId => _productId;
  String get productCode => _productCode;
  String get productName => _productName;

  String get itemMetrics => _itemMetrics;
  double get quantity => _quantity;

  double get qtyRefunded => _qtyRefunded;
  String get refundReason => _refundReason;

  double get unitBP => _unitBP;
  double get unitSellingPrice => _unitSellingPrice;

  String get userEmail => _userEmail;

  set soldItemId(int newSoldItemId) {
    soldItemId = newSoldItemId;
  }

  set txnId(int newTxnId) {
    txnId = newTxnId;
  }

  set productId(int newPId) {
    productId = newPId;
  }

  set productCode(String newPcode) {
    if (newPcode != '') {
      _productCode = newPcode;
    }
  }

  set productName(String newPname) {
    if (newPname != '') {
      _productName = newPname;
    }
  }

  set itemMetrics(String newItemMetrics) {
    if (newItemMetrics != '') {
      _itemMetrics = newItemMetrics;
    }
  }

  set quantity(double newQty) {
    if (newQty >= 0.0) {
      _quantity = newQty;
    }
  }

  set qtyRefunded(double newQtyRefunded) {
    if (newQtyRefunded >= 0.0) {
      _qtyRefunded = newQtyRefunded;
    }
  }

  set refundReason(String newRefundReason) {
    if (newRefundReason != '') {
      _refundReason = newRefundReason;
    }
  }

  set unitBP(double newUbp) {
    if (newUbp >= 0.0) {
      _unitBP = newUbp;
    }
  }

  set unitSellingPrice(double newUsp) {
    if (newUsp >= 0.0) {
      _unitSellingPrice = newUsp;
    }
  }

  set userEmail(String newUserEmail) {
    if (newUserEmail != '') {
      _refundReason = newUserEmail;
    }
  }

  /// -- convert a CCreditItem Object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (soldItemId != null) {
      map['soldItemId'] = _soldItemId;
    }
    map['txnId'] = _txnId;
    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;
    map['itemMetrics'] = _itemMetrics;
    map['quantity'] = _quantity;
    map['qtyRefunded'] = _qtyRefunded;
    map['refundReason'] = _refundReason;
    map['unitBP'] = _unitBP;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['userEmail'] = _userEmail;
    return map;
  }

  /// -- extract a CSoldItemModel Object from a Map object --
  CSoldItemModel.fromMapObject(Map<String, dynamic> map) {
    _soldItemId = map['soldItemId'];
    _txnId = map['txnId'];
    _productId = map['productId'];
    _productCode = map['productCode'];
    _productName = map['productName'];
    _itemMetrics = map['itemMetrics'];
    _quantity = map['quantity'];
    _qtyRefunded = map['qtyRefunded'];
    _refundReason = map['refundReason'];
    _unitBP = map['unitBP'];
    _unitSellingPrice = map['unitSellingPrice'];
    _userEmail = map['userEmail'];
  }

  /// -- factory method to create an CTxnsModel from a Firebase document snapshot --
  factory CSoldItemModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> salesDocument,
  ) {
    if (salesDocument.data() == null) return CSoldItemModel.empty();

    final soldItemData = salesDocument.data()!;

    return CSoldItemModel.withId(
      int.parse(salesDocument.id),
      soldItemData['txnId'],
      soldItemData['productId'],
      soldItemData['productCode'],
      soldItemData['productName'],
      soldItemData['itemMetrics'],
      soldItemData['quantity'],
      soldItemData['qtyRefunded'],
      soldItemData['refundReason'],
      soldItemData['unitBP'],
      soldItemData['unitSellingPrice'],
      soldItemData['userEmail'],
    );
  }
}
