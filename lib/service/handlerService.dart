Map<String, Function> getShortForm() {
  Map<String, Function> data;
  data = {
    "getCustomerShortForm": (customer) {
      var data = {};
      data['id'] = customer["_id"] != null ? customer["_id"].id.hexString : "";
      data["name"] = customer["name"] ?? "";
      data["belongs_to_customer"] = customer["belongs_to_customer"];
      data["phone_no"] = customer["phone_no"];
      data["address"] = customer["address"];
      return data;
    },
    "getLogInCustAddress": (data) async {
      List<dynamic> res = [];
      print('inside getlogin cust address');
      if (data.isNotEmpty && data[0]["address"] != null) {
        res.add(data[0]["address"]["name"] ?? "");
        res.add(data[0]["address"]["address"] ?? "");
        res.add(data[0]["address"]["landmark"] ?? "");
      }
      return res.length != 0 ? res.join(", ") : null;
    },
    "getSelectedCustAddress": (data) async {
      List<dynamic> res = [];
      print('inside getlogin cust address');
      if (data.isNotEmpty && data.length > 0 && data[0]["address"] != null) {
        res.add(data[0]["address"]["name"] ?? "");
        res.add(data[0]["address"]["address"] ?? "");
        res.add(data[0]["address"]["landmark"] ?? "");
      }
      return res.length != 0 ? res.join(", ") : null;
    },
    "getAddressFromOrders": (order) {
      List<dynamic> res = [];
      dynamic address = order["belongs_to_customer"]["address"];
      print('inside getlogin cust address');
      if (order.isNotEmpty && address != null) {
        res.add(address["name"] ?? "");
        res.add(address["address"] ?? "");
        res.add(address["landmark"] ?? "");
      }
      return res.length != 0 ? res.join(", ") : null;
    },
    "getAddressForOrder": (address) {
      List<dynamic> res = [];
      // dynamic address = customer["belongs_to_customer"]["address"];
      print('inside getlogin cust address');
      if (address.isNotEmpty && address != null) {
        res.add(address["name"] ?? "");
        res.add(address["address"] ?? "");
        res.add(address["landmark"] ?? "");
      }
      return res.length != 0 ? res.join(", ") : null;
    },
  };
  return data;
}

getHandler() {
  Map<String, Function> data;
  data = {
    "productAction": (srv, action, state, dtLastAction, orderId) async {
      await srv.saveForm(
          'orders',
          {
            "last_action": action,
            "status": state,
            "dt_last_action": dtLastAction
          },
          orderId);
    }
  };
  return data;
}
