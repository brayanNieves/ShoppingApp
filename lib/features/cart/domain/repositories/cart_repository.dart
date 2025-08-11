import 'package:shoppingapp/features/products/domain/entities/product.dart';

import '../../domain/entities/cart_item.dart';

abstract class CartRepository {
  Stream<List<CartItem>> watchCart(String uid);

  Future<void> add(String uid, Product product, {int quantity = 1});

  Future<void> remove(String uid, String productId);

  Future<void> updateQuantity(String uid, String productId, int quantity);

  Future<void> clear(String uid);
}
