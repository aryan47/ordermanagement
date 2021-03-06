Map<String, Function> getShortForm() {
  Map<String, Function> data;
  data = {
    "getCustomerShortForm": (customer) {
      var data = {};
      data['id'] = customer["_id"].id.hexString;
      data["name"] = customer["name"];
      data["belongs_to_customer"] = customer["belongs_to_customer"];
      data["phone_no"] = customer["phone_no"];
      data["address"] = customer["address"];
      return data;
    }
  };
  return data;
}
