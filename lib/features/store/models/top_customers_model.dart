// ignore_for_file: unnecessary_getters_setters

class CTopCustomer {
  double _totalAmount = 0.0;
  int _txnsCount = 0;
  String _customerContacts = '';
  String _customerName = '';

  CTopCustomer(
    this._customerContacts,
    this._customerName,
    this._totalAmount,
    this._txnsCount,
  );

  double get totalAmount {
    return _totalAmount;
  }

  int get txnsCount {
    return _txnsCount;
  }

  String get customerContacts {
    return _customerContacts;
  }

  String get customerName {
    return _customerName;
  }

  set customerContacts(String cContact) {
    _customerContacts = cContact;
  }

  set customerName(String cName) {
    _customerName = cName;
  }

  set totalAmount(double tAmt) {
    _totalAmount = tAmt;
  }

  set txnsCount(int count) {
    _txnsCount = count;
  }

  /// -- convert a CTopCustomer Object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['customerContacts'] = _customerContacts;
    map['customerName'] = _customerName;
    map['totalAmount'] = _totalAmount;
    map['txnsCount'] = _txnsCount;

    return map;
  }

  /// -- extract a CTopCustomer object from a Map object --
  CTopCustomer.fromMapObject(Map<String, dynamic> map) {
    _customerContacts = map['customerContacts'];
    _customerName = map['customerName'];
    _totalAmount = map['totalAmount'];
    _txnsCount = map['txnsCount'];
  }
}
