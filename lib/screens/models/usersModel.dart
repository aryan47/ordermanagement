import 'package:firebase_auth/firebase_auth.dart';
import 'package:mongo_dart/mongo_dart.dart';
// not getting used.
class UsersM {
  ObjectId _id;
  DateTime _dtCreated;
  DateTime _dtLastLogin;
  String _phoneNumber;
  String _role;
  bool _isActive;
  String _uid;

  UsersM();

  UsersM.create(
    this._id,
    this._uid,
    this._phoneNumber,
    this._role,
    this._dtCreated,
    this._dtLastLogin,
    this._isActive,
  );

  set uid(uid) => _uid = uid;
  set phoneNumber(phone) => _phoneNumber = phone;
  set role(role) => _role = role;
  set dtCreated(created) => _dtCreated = created;
  set dtLastLogin(lastLogin) => _dtLastLogin = lastLogin;
  set isActive(active) => _isActive = active;

  String get uid => _uid;
  String get phoneNumber => _phoneNumber;
  String get role => _role;
  DateTime get dtCreated => _dtCreated;
  DateTime get dtLastLogin => _dtLastLogin;
  bool get isActive => _isActive;

  Future<UsersM> createUser(db) async {
    var user = FirebaseAuth.instance.currentUser;
    UsersM model = UsersM();
    if (user != null) {
      model.uid = user.uid;
      model.phoneNumber = user.phoneNumber;
      model.role = "K_USER";
    }
    var data = await db.collection("users").save(model);
    print(data);
    return data;
  }

  Future<UsersM> getCurrentUser(db) async {
    var user = FirebaseAuth.instance.currentUser;
    var data = await db
        .collection("users")
        .find(where.eq("phoneNumber", user.phoneNumber))
        .toList();
    return data;
  }

  factory UsersM.fromJson(dynamic json) {
    return UsersM.create(
        json['_id'] as ObjectId,
        json['_uid'] as String,
        json['_phoneNumber'] as String,
        json['_role'] as String,
        json['_dtCreated'] as DateTime,
        json['_dtLastLogin'] as DateTime,
        json['_isActive'] as bool);
  }

  Map<String, dynamic> toMap() {
    // return {'id': id, 'content': content, 'title': title};
    return null;
  }
}
