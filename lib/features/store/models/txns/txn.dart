// ignore_for_file: unnecessary_getters_setters, prefer_final_fields

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rintel/features/store/models/txns/txn_item.dart';

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
  List<CTxnItem> _items = <CTxnItem>[];

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
    this._items,
  );

  // CInvoicesModel.withId(
  //   this._invoiceId,
  //   this._txnId,
  //   this._userId,
  //   this._userEmail,
  //   this._userName,
  //   this._amountPaid,
  //   this._totalAmount,
  //   this._discount,
  //   this._paymentMethod,
  //   this._customerName,
  //   this._customerContacts,
  //   this._dateAdded,
  //   this._lastModified,
  //   this._txnStatus,
  //   this._txnAddress,
  //   this._txnAddressCoordinates,
  //   this._items,
  // );

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
      [],
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
  List<CTxnItem> get items => _items;

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

  set items(List<CTxnItem> newItemsList) {
    _items = newItemsList;
  }

  // convert a CInvoicesModel Object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'txnId': _txnId,
      'userId': _userId,
      'userEmail': _userEmail,
      'userName': _userName,
      'amountPaid': _amountPaid,
      'totalAmount': _totalAmount,
      'discount': _discount,
      'paymentMethod': _paymentMethod,
      'customerName': _customerName,
      'customerContacts': _customerContacts,
      'txnAddress': _txnAddress,
      'txnAddressCoordinates': _txnAddressCoordinates,
      'dateAdded': _dateAdded,
      'lastModified': _lastModified,
      'txnStatus': _txnStatus,
      'items': jsonEncode(
        _items.map((e) => e.toMap()).toList(),
      ),
    };
  }

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
      salesData['items'],
    );
  }

  // extract a CInvoicesModel object from a Map object
  factory CTxn.fromMap(Map<String, dynamic> map) {
    return CTxn(
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
      (map['items'] as List)
          .map(
            (i) => CTxnItem.fromMapObject(i),
          ) // Convert each map to SubItem
          .toList(),
    );
  }
  // CInvoicesModel.fromMapObject(Map<String, dynamic> map) {
  //   _invoiceId = map['invoiceId'];
  //   _txnId = map['txnId'];
  //   _userId = map['userId'];
  //   _userEmail = map['userEmail'];
  //   _userName = map['userName'];
  //   _amountPaid = map['amountPaid'];
  //   _totalAmount = map['totalAmount'];

  //   _discount = map['discount'];
  //   _paymentMethod = map['paymentMethod'];
  //   _customerName = map['customerName'];
  //   _customerContacts = map['customerContacts'];
  //   _txnAddress = map['txnAddress'];
  //   _txnAddressCoordinates = map['txnAddressCoordinates'];
  //   _dateAdded = map['dateAdded'];
  //   _lastModified = map['lastModified'];
  //   _txnStatus = map['txnStatus'];
  // }
}
