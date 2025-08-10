import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/product.dart';

abstract class IProductRepository {
  Future<List<Product>> fetchProducts();

  Future<Product?> getById(String id);
}

class LocalProductRepository implements IProductRepository {
  List<Product>? _cache;

  @override
  Future<List<Product>> fetchProducts() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/products.json');
    final list = (json.decode(raw) as List).cast<Map<String, dynamic>>();
    _cache = list.map(Product.fromJson).toList();
    return _cache!;
  }

  @override
  Future<Product?> getById(String id) async {
    final products = await fetchProducts();
    try {
      return products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
