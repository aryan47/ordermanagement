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
