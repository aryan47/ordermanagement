class ProductService {
  var cache;
  Future getProducts(db) async {
    if (cache != null) return cache;
    cache = await db.collection("products").find().toList();
    return cache;
  }
}
