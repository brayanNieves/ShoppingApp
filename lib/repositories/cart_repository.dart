import 'dart:async';
import '../models/cart_item.dart';
import '../models/product.dart';

abstract class ICartRepository {
  Stream<List<CartItem>> watchCart();
  Future<void> add(Product product, {int quantity = 1});
  Future<void> remove(String productId);
  Future<void> updateQuantity(String productId, int quantity);
  Future<void> clear();
}

/// Implementación en memoria (por defecto)
class MemoryCartRepository implements ICartRepository {
  final List<CartItem> _items = [];
  final StreamController<List<CartItem>> _controller =
      StreamController<List<CartItem>>.broadcast();

  @override
  Stream<List<CartItem>> watchCart() {
    _controller.add(List.unmodifiable(_items));
    return _controller.stream;
  }

  @override
  Future<void> add(Product product, {int quantity = 1}) async {
    final index = _items.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: quantity));
    } else {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: current.quantity + quantity);
    }
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<void> remove(String productId) async {
    _items.removeWhere((e) => e.product.id == productId);
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    final index = _items.indexWhere((e) => e.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
      _controller.add(List.unmodifiable(_items));
    }
  }

  @override
  Future<void> clear() async {
    _items.clear();
    _controller.add(List.unmodifiable(_items));
  }
}
