import 'package:mongo_dart/mongo_dart.dart';

class CustomersM {
  ObjectId id;
  String customer_name;
  DateTime dt_join;
  String address;
  String landmark;
  int pincode;
  String phone_no;
  bool is_active;
  int charge_per_order;

  CustomersM(
      this.id,
      this.customer_name,
      this.dt_join,
      this.address,
      this.landmark,
      this.pincode,
      this.phone_no,
      this.is_active,
      this.charge_per_order);

  factory CustomersM.fromJson(dynamic json) {
    return CustomersM(
        json['_id'] as ObjectId,
        json['customer_name'] as String,
        json['dt_join'] as DateTime,
        json['address'] as String,
        json['landmark'] as String,
        json['pincode'] as int,
        json['phone_no'] as String,
        json['is_active'] as bool,
        json['charge_per_order'] as int);
  }

  Map<String, dynamic> toMap() {
    // return {'id': id, 'content': content, 'title': title};
    return null;
  }

  dynamic find() {}
}
