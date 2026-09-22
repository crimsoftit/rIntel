// ignore_for_file: unnecessary_getters_setters, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CExpense extends Equatable {
  int _expenseId = 0;

  String _userId = '';
  String _userEmail = "";
  String _userName = "";

  String _expenseTitle = "";
  String _expenseDescription = '';

  double _amount = 0.0;

  String _dateAdded = "";
  String _lastModified = "";

  CExpense(
    this._expenseId,
    this._userId,
    this._userEmail,
    this._userName,
    this._expenseTitle,
    this._expenseDescription,
    this._amount,
    this._dateAdded,
    this._lastModified,
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
    );
  }

  int get expenseId => _expenseId;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  String get expenseTitle => _expenseTitle;
  String get expenseDescription => _expenseDescription;
  double get amount => _amount;
  String get dateAdded => _dateAdded;
  String get lastModified => _lastModified;

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

  set expenseTitle(String newExpenseTitle) {
    _expenseTitle = newExpenseTitle;
  }

  set expenseDescription(String newDesc) {
    _expenseDescription = newDesc;
  }

  set amount(double newAmount) {
    _amount = newAmount;
  }

  set dateAdded(String newDateAdded) {
    _dateAdded = newDateAdded;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  /// -- convert a CExpense Object into a Map 0bject --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['expenseId'] = _expenseId;
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;
    map['expenseTitle'] = _expenseTitle;
    map['expenseDescription'] = _expenseDescription;
    map['amount'] = _amount;
    map['dateAdded'] = _dateAdded;
    map['lastModified'] = _lastModified;

    return map;
  }

  /// -- extract a CExpense Object from a Map Object --
  CExpense.fromMap(Map<String, dynamic> map) {
    _expenseId = map['expenseId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];
    _expenseTitle = map['expenseTitle'];
    _expenseDescription = map['expenseDescription'];
    _amount = map['amount'];
    _dateAdded = map['dateAdded'];
    _lastModified = map['lastModified'];
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
      expenditure['expenseTitle'],
      expenditure['expenseDescription'],
      expenditure['amount'],
      expenditure['dateAdded'],
      expenditure['lastModified'],
    );
  }

  @override
  List<Object?> get props => [
    expenseId,
    userId,
    userEmail,
    userName,
    expenseTitle,
    expenseDescription,
    amount,
    dateAdded,
    lastModified,
  ];
  // List<Object?> get props => throw UnimplementedError();
}
