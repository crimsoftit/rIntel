// ignore_for_file: unnecessary_getters_setters, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CExpense extends Equatable {
  int _expenseId = 0;

  String _userId = '';
  String _userEmail = "";
  String _userName = "";

  String _expenseCategory = "";
  String _expenseDescription = '';

  double _amount = 0.0;

  String _recipientName = '';
  String _recipientContact = '';
  String _recipientCountry = '';

  String _dateAdded = "";
  String _lastModified = "";
  String _txnCode = '';

  CExpense(
    this._expenseId,
    this._userId,
    this._userEmail,
    this._userName,
    this._expenseCategory,
    this._expenseDescription,
    this._amount,
    this._recipientName,
    this._recipientContact,
    this._recipientCountry,
    this._dateAdded,
    this._lastModified,
    this._txnCode,
  );

  static CExpense empty() {
    return CExpense(
      0,
      '',
      '',
      '',
      '',
      '',
      0.0,
      '',
      '',
      '',
      '',
      '',
      '',
    );
  }

  int get expenseId => _expenseId;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String get expenseCategory => _expenseCategory;
  String get expenseDescription => _expenseDescription;
  double get amount => _amount;
  String get recipientName => _recipientName;
  String get recipientContact => _recipientContact;
  String get recipientCountry => _recipientCountry;
  String get dateAdded => _dateAdded;
  String get lastModified => _lastModified;
  String get txnCode => _txnCode;

  set expenseId(int newId) {
    _expenseId = newId;
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

  set expenseCategory(String newExpenseCategory) {
    _expenseCategory = newExpenseCategory;
  }

  set expenseDescription(String newDesc) {
    _expenseDescription = newDesc;
  }

  set amount(double newAmount) {
    _amount = newAmount;
  }

  set recipientName(String rName) {
    _recipientName = rName;
  }

  set recipientContact(String rContact) {
    _recipientContact = rContact;
  }

  set recipientCountry(String newCountry) {
    _recipientCountry = newCountry;
  }

  set dateAdded(String newDateAdded) {
    _dateAdded = newDateAdded;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  set txnCode(String newTxnCode) {
    _txnCode = newTxnCode;
  }

  /// -- convert a CExpense Object into a Map 0bject --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['expenseId'] = _expenseId;
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;
    map['expenseCategory'] = _expenseCategory;
    map['expenseDescription'] = _expenseDescription;
    map['amount'] = _amount;
    map['recipientName'] = _recipientName;
    map['recipientContact'] = _recipientContact;
    map['recipientCountry'] = _recipientCountry;
    map['dateAdded'] = _dateAdded;
    map['lastModified'] = _lastModified;
    map['txnCode'] = _txnCode;

    return map;
  }

  /// -- extract a CExpense Object from a Map Object --
  CExpense.fromMap(Map<String, dynamic> map) {
    _expenseId = map['expenseId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];
    _expenseCategory = map['expenseCategory'];
    _expenseDescription = map['expenseDescription'];
    _amount = map['amount'];
    _recipientName = map['recipientName'];
    _recipientContact = map['recipientContact'];
    _recipientCountry = map['recipientCountry'];
    _dateAdded = map['dateAdded'];
    _lastModified = map['lastModified'];
    _txnCode = map['txnCode'];
  }

  /// -- factory method to create a CExpense model from a Firebase document snapshot --
  factory CExpense.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    // -- null check --
    if (doc.data() == null) return CExpense.empty();

    final expenditure = doc.data()!;
    return CExpense(
      int.parse(doc.id),
      expenditure['userId'],
      expenditure['userEmail'],
      expenditure['userName'],
      expenditure['expenseCategory'],
      expenditure['expenseDescription'],
      expenditure['amount'],
      expenditure['recipientName'],
      expenditure['recipientContact'],
      expenditure['recipientCountry'],
      expenditure['dateAdded'],
      expenditure['lastModified'],
      expenditure['txnCode'],
    );
  }

  @override
  List<Object?> get props => [
    expenseId,
    userId,
    userEmail,
    userName,
    expenseCategory,
    expenseDescription,
    amount,
    recipientName,
    recipientContact,
    recipientCountry,
    dateAdded,
    lastModified,
    txnCode,
  ];
  // List<Object?> get props => throw UnimplementedError();
}
