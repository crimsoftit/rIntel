// ignore_for_file: unnecessary_getters_setters, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rintel/features/store/models/txns/sold_item_model.dart';

class CTxn {
  int _txnId = 0;
  String _userId = "";
  String _userEmail = "";
  String _userName = "";
  double _amountPaid = 0.0;
  double _totalAmount = 0.0;
  double _discount = 0.0;
  String _paymentMethod = "";
  String _customerName = "";
  String _customerContacts = "";
  String _dateAdded = "";
  String _lastModified = "";
  String _txnStatus = "";
  String _txnAddress = "";
  String _txnAddressCoordinates = "";
  List<CSoldItemModel>? _txnItems;

  CTxn(
    //this._invoiceId,
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._amountPaid,
    this._totalAmount,
    this._discount,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._dateAdded,
    this._lastModified,
    this._txnStatus,
    this._txnAddress,
    this._txnAddressCoordinates,
  );

  CTxn.withItems(
    //this._invoiceId,
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._amountPaid,
    this._totalAmount,
    this._discount,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._dateAdded,
    this._lastModified,
    this._txnStatus,
    this._txnAddress,
    this._txnAddressCoordinates,
    this._txnItems,
  );

  static CTxn empty() {
    return CTxn(
      0,
      '',
      '',
      '',
      0.0,
      0.0,
      0.0,
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
    );
  }

  int get txnId => _txnId;

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;

  double get amountPaid => _amountPaid;
  double get totalAmount => _totalAmount;

  double get discount => _discount;

  String get paymentMethod => _paymentMethod;

  String get customerName => _customerName;
  String get customerContacts => _customerContacts;

  String get dateAdded => _dateAdded;
  String get lastModified => _lastModified;

  String get txnStatus => _txnStatus;
  String get txnAddress => _txnAddress;
  String get txnAddressCoordinates => _txnAddressCoordinates;
  List<CSoldItemModel>? get txnItems => _txnItems;

  set txnId(int newTxnId) {
    _txnId = newTxnId;
  }

  set userId(String newUid) {
    _userId = newUid;
  }

  set userEmail(String newUEmail) {
    _userEmail = newUEmail;
  }

  set userName(String newUName) {
    _userName = newUName;
  }

  set amountPaid(double newAmountPaid) {
    _amountPaid = newAmountPaid;
  }

  set totalAmount(double newTotalAmount) {
    _totalAmount = newTotalAmount;
  }

  set discount(double newDiscount) {
    _discount = newDiscount;
  }

  set paymentMethod(String newPaymentMethod) {
    _paymentMethod = newPaymentMethod;
  }

  set customerName(String newCustomerName) {
    _customerName = newCustomerName;
  }

  set customerContacts(String newCustomerContacts) {
    _customerContacts = newCustomerContacts;
  }

  set txnAddress(String newTxnAddress) {
    _txnAddress = newTxnAddress;
  }

  set txnAddressCoordinates(String newTxnAddressCoordinates) {
    _txnAddressCoordinates = newTxnAddressCoordinates;
  }

  set dateAdded(String newDateAdded) {
    _dateAdded = newDateAdded;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  set txnStatus(String newTxnStatus) {
    _txnStatus = newTxnStatus;
  }

  set txnItems(List<CSoldItemModel>? newTxnItems) {
    _txnItems = newTxnItems;
  }

  // convert a CInvoicesModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['txnId'] = _txnId;
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;
    map['amountPaid'] = _amountPaid;
    map['totalAmount'] = _totalAmount;
    map['discount'] = _discount;
    map['paymentMethod'] = _paymentMethod;
    map['customerName'] = _customerName;
    map['customerContacts'] = _customerContacts;
    map['txnAddress'] = _txnAddress;
    map['txnAddressCoordinates'] = _txnAddressCoordinates;
    map['dateAdded'] = _dateAdded;
    map['lastModified'] = _lastModified;
    map['txnStatus'] = _txnStatus;
    if (_txnItems != null) {
      map['txnItems'] = _txnItems!.map((item) => item.toMap()).toList();
    }
    return map;
  }
  // Map<String, dynamic> toMap() {
  //   return {
  //     'txnId': _txnId,
  //     'userId': _userId,
  //     'userEmail': _userEmail,
  //     'userName': _userName,
  //     'amountPaid': _amountPaid,
  //     'totalAmount': _totalAmount,
  //     'discount': _discount,
  //     'paymentMethod': _paymentMethod,
  //     'customerName': _customerName,
  //     'customerContacts': _customerContacts,
  //     'txnAddress': _txnAddress,
  //     'txnAddressCoordinates': _txnAddressCoordinates,
  //     'dateAdded': _dateAdded,
  //     'lastModified': _lastModified,
  //     'txnStatus': _txnStatus,
  //     'txnItems': _txnItems?.map((item) => item.toMap()).toList(),
  //   };
  // }

  /// -- factory method to create an CTxnsModel from a Firebase document snapshot --
  factory CTxn.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> txnsDocument,
  ) {
    if (txnsDocument.data() == null) return CTxn.empty();
    final salesData = txnsDocument.data()!;

    return CTxn(
      int.parse(txnsDocument.id),
      salesData['userId'],
      salesData['userEmail'],
      salesData['userName'],
      salesData['amountPaid'],
      salesData['totalAmount'],
      salesData['discount'],
      salesData['paymentMethod'],
      salesData['customerName'],
      salesData['customerContacts'],
      salesData['dateAdded'],
      salesData['lastModified'],
      salesData['txnStatus'],
      salesData['txnAddress'],
      salesData['txnAddressCoordinates'],
    );
  }

  // extract a CInvoicesModel object from a Map object
  factory CTxn.fromMap(Map<String, dynamic> map) {
    return CTxn.withItems(
      map['txnId'],
      map['userId'],
      map['userEmail'],
      map['userName'],
      map['amountPaid'],
      map['totalAmount'],
      map['discount'],
      map['paymentMethod'],
      map['customerName'],
      map['customerContacts'],
      map['dateAdded'],
      map['lastModified'],
      map['txnStatus'],
      map['txnAddress'],
      map['txnAddressCoordinates'],
      map['txnItems'] != null
          ? List<CSoldItemModel>.from(
              map['txnItems'].map((item) => CSoldItemModel.fromMapObject(item)),
            )
          : null,
    );
  }
}
