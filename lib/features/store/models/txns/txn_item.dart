class CTxnItem {
  int _productId = 0;
  String _productCode = "";
  String _productName = "";

  String _itemMetrics = '';
  double _quantity = 0;
  double _qtyRefunded = 0;
  String _refundReason = "";
  double _unitBP = 0.0;
  double _unitSellingPrice = 0.0;

  CTxnItem(
    this._productId,
    this._productCode,
    this._productName,
    this._itemMetrics,
    this._quantity,
    this._qtyRefunded,
    this._refundReason,
    this._unitBP,
    this._unitSellingPrice,
  );

  static CTxnItem empty() {
    return CTxnItem(
      0,
      '',
      '',
      '',
      0.0,
      0.0,
      '',
      0.0,
      0.0,
    );
  }

  int get productId => _productId;
  String get productCode => _productCode;
  String get productName => _productName;

  String get itemMetrics => _itemMetrics;
  double get quantity => _quantity;

  double get qtyRefunded => _qtyRefunded;
  String get refundReason => _refundReason;

  double get unitBP => _unitBP;
  double get unitSellingPrice => _unitSellingPrice;

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

  /// -- convert a CCreditItem Object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;
    map['itemMetrics'] = _itemMetrics;
    map['quantity'] = _quantity;
    map['qtyRefunded'] = _qtyRefunded;
    map['refundReason'] = _refundReason;
    map['unitBP'] = _unitBP;
    map['unitSellingPrice'] = _unitSellingPrice;

    return map;
  }

  /// -- extract a CCreditItem Object from a Map object --
  CTxnItem.fromMapObject(Map<String, dynamic> map) {
    _productId = map['productId'];
    _productCode = map['productCode'];
    _productName = map['productName'];
    _itemMetrics = map['itemMetrics'];
    _quantity = map['quantity'];
    _qtyRefunded = map['qtyRefunded'];
    _refundReason = map['refundReason'];
    _unitBP = map['unitBP'];
    _unitSellingPrice = map['unitSellingPrice'];
  }
}
