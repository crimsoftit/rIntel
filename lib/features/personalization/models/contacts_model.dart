// ignore_for_file = unnecessary_getters_setters

// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';

import 'package:rintel/features/personalization/models/gsheets_contact_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CContactsModel {
  int? _contactId;

  String _addedBy = '';
  String _contactName = '';
  String _contactCountryCode = '';
  String _contactDialCode = '';
  String _contactPhone = '';
  String _contactEmail = '';
  String _contactCategory = '';
  String _lastModified = '';
  String _createdAt = '';
  int _isStarred = 0;
  int _isTrashed = 0;

  String? _tag = '';

  CContactsModel(
    this._addedBy,
    this._contactName,
    this._contactCountryCode,
    this._contactDialCode,
    this._contactPhone,
    this._contactEmail,
    this._contactCategory,
    this._lastModified,
    this._createdAt,
    this._isStarred,
    this._isTrashed,
  );

  CContactsModel.withId(
    this._contactId,
    this._addedBy,
    this._contactName,
    this._contactCountryCode,
    this._contactDialCode,
    this._contactPhone,
    this._contactEmail,
    this._contactCategory,
    this._lastModified,
    this._createdAt,
    this._isStarred,
    this._isTrashed,
  );

  CContactsModel.withTagAndTitle(
    this._contactName,
    this._tag,
  );

  static CContactsModel empty() {
    return CContactsModel(
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      0,
      0,
    );
  }

  int? get contactId => _contactId;
  String get addedBy => _addedBy;
  String get contactName => _contactName;
  String get contactCountryCode => _contactCountryCode;
  String get contactDialCode => _contactDialCode;
  String get contactPhone => _contactPhone;
  String get contactEmail => _contactEmail;
  String get contactCategory => _contactCategory;
  String get lastModified => _lastModified;
  String get createdAt => _createdAt;
  int get isTrashed => _isTrashed;
  int get isStarred => _isStarred;

  String? get tag => _tag;

  set addedBy(String deviceUser) {
    _addedBy = deviceUser;
  }

  set contactName(String newContactName) {
    _contactName = newContactName;
  }

  set contactCountryCode(String newCountryCode) {
    _contactCountryCode = newCountryCode;
  }

  set contactDialCode(String newDialCode) {
    _contactDialCode = newDialCode;
  }

  set contactPhone(String newContactPhone) {
    _contactPhone = newContactPhone;
  }

  set contactEmail(String newContactEmail) {
    _contactEmail = newContactEmail;
  }

  set contactCategory(String newContactCategory) {
    _contactCategory = newContactCategory;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  set createdAt(String newCreatedAt) {
    _createdAt = newCreatedAt;
  }

  set isStarred(int newStar) {
    _isStarred = newStar;
  }

  set isTrashed(int trashStatus) {
    _isTrashed = trashStatus;
  }

  set tag(String? newTag) {
    _tag = newTag;
  }

  /// -- convert a Contact object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (contactId != null) {
      map['contactId'] = _contactId;
    }
    map['addedBy'] = _addedBy;
    map['contactName'] = _contactName;
    map['contactCountryCode'] = _contactCountryCode;
    map['contactDialCode'] = _contactDialCode;
    map['contactPhone'] = _contactPhone;
    map['contactEmail'] = _contactEmail;
    map['contactCategory'] = _contactCategory;
    map['lastModified'] = _lastModified;
    map['createdAt'] = _createdAt;
    map['isStarred'] = _isStarred;
    map['isTrashed'] = _isTrashed;

    return map;
  }

  /// -- extract a Contact object from a Map object --
  CContactsModel.fromMapObject(Map<String, dynamic> map) {
    _contactId = map['contactId'];
    _addedBy = map['addedBy'];
    _contactName = map['contactName'];
    _contactCountryCode = map['contactCountryCode'];
    _contactDialCode = map['contactDialCode'];
    _contactPhone = map['contactPhone'];
    _contactEmail = map['contactEmail'];
    _contactCategory = map['contactCategory'];
    _lastModified = map['lastModified'];
    _createdAt = map['createdAt'];
    _isStarred = map['isStarred'];
    _isTrashed = map['isTrashed'];
  }

  /// -- extract a CContactsModel object from a Gsheet Map object --
  static CContactsModel gSheetsFromJson(Map<String, dynamic> json) {
    return CContactsModel.withId(
      jsonDecode(json[GsheetsContactModel.contactId]),
      json[GsheetsContactModel.addedBy],
      json[GsheetsContactModel.contactName],
      json[GsheetsContactModel.contactCountryCode],
      json[GsheetsContactModel.contactDialCode],
      json[GsheetsContactModel.contactPhone],
      json[GsheetsContactModel.contactEmail],
      json[GsheetsContactModel.contactCategory],
      json[GsheetsContactModel.lastModified],
      json[GsheetsContactModel.createdAt],
      jsonDecode(json[GsheetsContactModel.isStarred]),
      jsonDecode(json[GsheetsContactModel.isTrashed]),
    );
  }

  /// -- factory method to create an CTxnsModel from a Firebase document snapshot --
  factory CContactsModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> contactDoc,
  ) {
    if (contactDoc.data() == null) return CContactsModel.empty();

    final contact = contactDoc.data()!;

    return CContactsModel.withId(
      int.parse(contactDoc.id),
      contact['addedBy'],
      contact['contactName'],
      contact['contactCountryCode'],
      contact['contactDialCode'],
      contact['contactPhone'],
      contact['contactEmail'],
      contact['contactCategory'],
      contact['lastModified'],
      contact['createdAt'],
      contact['isStarred'],
      contact['isTrashed'],
    );
  }
}
