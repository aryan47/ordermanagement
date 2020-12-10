Map<String, Function> getShortForm() {
    Map<String, Function> data;
    data = {
      "getCustomerShortForm": (customer) {
        var data = {};
        data['id'] = customer["_id"].id.hexString;
        data["name"] = customer["name"];
        data["phone_no"] = customer["phone_no"];
        data["address"] = customer["address"];
        return data;
      }
    };
    return data;
  }