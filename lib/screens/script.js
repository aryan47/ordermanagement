db.orders.find().forEach(function (order) {
  var name = order.customer_name;
  var cust = db.customers.findOne({ customer_name: name });
  if (!cust) print("not found", name);
  order.belongs_to_customer = cust._id;
  db.orders.save(order)
});

db.orders.find().forEach(function (order) {
    order.belongs_to_customer = order.belongs_to_customer.str;
    db.orders.save(order);
});

db.customers.find().forEach(function(customer) {
  var address = {};
  address.line1 = customer.address;
  address.landmark = customer.landmark;
  address.pincode = customer.pincode;
  customer.address = address;
  db.customers.save(customer);
})


db.customers.find().forEach(function(customer){
  if(!customer.address.line1){
    print(customer.address.line1)
  }
  // db.customers.save(customer)
})

db.customer.deleteOne({_id:  ObjectId("604f6ad83f0a1a0ccb874efb")})

db.customers.insertOne({
  customer_name: "unknown shekar rent",
  dt_join: ISODate("2020-11-28T18:30:00Z"),
  address: "Morabadi",
  landmark: "sai apartment",
  pincode: 834008,
  phone_no: "",
  is_active: true,
  charge_per_order: 20,
});
