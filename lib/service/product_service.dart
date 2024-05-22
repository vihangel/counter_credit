import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:firebase_database/firebase_database.dart';

class ProductService {
  final DatabaseReference _productsRef =
      FirebaseDatabase.instance.ref().child('produtos');

  Future<void> addProduct(Product product) {
    // Esta função adiciona um produto usando o índice numérico como chave, que parece ser o esquema atual.
    return _productsRef.child(product.id.toString()).set(product.toJson());
  }

  Future<void> updateProduct(Product product) {
    // Atualiza um produto no mesmo índice.
    return _productsRef.child(product.id.toString()).update(product.toJson());
  }

  Future<void> deleteProduct(String id) {
    // Remove o produto no índice especificado
    return _productsRef.child(id).remove();
  }

  Future<void> addProductWithAutoId(Product product) {
    DatabaseReference newProductRef =
        _productsRef.push(); // Cria um novo nó com ID único
    return newProductRef.set(product.toJson());
  }

  // Sua função existente de getProducts está funcionando, então não será modificada.
  Future<List<Product>> getProducts() async {
    final DatabaseEvent event = await _productsRef.once();
    List<Product> products = [];

    if (event.snapshot.value != null) {
      final Map value = event.snapshot.value as Map;
      value.forEach((key, data) {
        products.add(Product.fromJson(Map<String, dynamic>.from(data))
            .copyWith(id: key));
      });
    }
    return products;
  }

  Future<Product> getProduct(String id) async {
    final DatabaseEvent event = await _productsRef.child(id).once();
    if (event.snapshot.value != null) {
      return Product.fromJson(Map<String, dynamic>.from(
              event.snapshot.value as Map<dynamic, dynamic>))
          .copyWith(id: id);
    } else {
      throw Exception('Product not found');
    }
  }
}
