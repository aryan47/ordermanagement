import 'package:mongo_dart/mongo_dart.dart';

class CustomersM {
  ObjectId? _id;
  String? name;
  String? phone_no;
  DateTime? dt_order_place;
  DateTime? dt_delivery;
  String? status;
  int? quantity;
  int? per_jar_price;
  int? payment_rcvd;
  int? payment_due;
  int? total_amount;
  bool? is_new;
  int? inst_amt;
  int? security_amt;
  ObjectId? belongs_to_customer;
  String? last_action;

  CustomersM(
      this._id,
      this.name,
      this.phone_no,
      this.dt_order_place,
      this.dt_delivery,
      this.status,
      this.quantity,
      this.per_jar_price,
      this.payment_rcvd,
      this.payment_due,
      this.total_amount,
      this.is_new,
      this.inst_amt,
      this.security_amt,
      this.belongs_to_customer,
      this.last_action);

  factory CustomersM.fromJson(dynamic json) {
    return CustomersM(
        json['_id'] as ObjectId?,
        json['name'] as String?,
        json['phone_no'] as String?,
        json['dt_order_place'] as DateTime?,
        json['dt_delivery'] as DateTime?,
        json['status'] as String?,
        json['quantity'] as int?,
        json['per_jar_price'] as int?,
        json['payment_rcvd'] as int?,
        json['payment_due'] as int?,
        json['total_amount'] as int?,
        json['is_new'] as bool?,
        json['inst_amt'] as int?,
        json['security_amt'] as int?,
        json['belongs_to_customer'] as ObjectId?,
        json['last_action'] as String?);
  }

  Map<String, dynamic>? toMap() {
    // return {'id': id, 'content': content, 'title': title};
    return null;
  }
}
