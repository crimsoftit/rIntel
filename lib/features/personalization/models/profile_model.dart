// ignore_for_file: unnecessary_getters_setters

class CProfileModel {
  int? _id;
  String _userId = '';
  String _userDp = '';

  CProfileModel({
    required this._userDp,
    required this._userId,
  });

  int? get id => _id;
  String get userId => _userId;
  String get userDp => _userDp;

  set id(int? newId) {
    _id = newId;
  }

  set userDp(String newUserDp) {
    _userDp = newUserDp;
  }

  set userId(String newUserId) {
    _userId = newUserId;
  }

  static CProfileModel empty() {
    return CProfileModel(
      userDp: '',
      userId: '',
    );
  }

  /// -- extract a CProfileModel object from a Map object --
  CProfileModel.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _userDp = map['userDp'];
    _userId = map['userId'];
  }

  /// -- convert a CProfileModel object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) map['id'] = _id;

    map['userDp'] = _userDp;
    map['userId'] = _userId;

    return map;
  }
}
