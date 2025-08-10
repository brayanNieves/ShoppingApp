// Implementación opcional con Firestore. Solo se utiliza si USE_FIREBASE=true
// Requiere: firebase_core, cloud_firestore, firebase_auth y firebase_options.dart generado por flutterfire.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import 'cart_repository.dart';

class FirestoreCartRepository implements ICartRepository {
  final String uid;
  final _coll;

  FirestoreCartRepository(this.uid)
      : _coll = FirebaseFirestore.instance.collection('carts').doc(uid).collection('items');

  @override
  Stream<List<CartItem>> watchCart() {
    return _coll.snapshots().map((snap) {
      return snap.docs.map((d) {
        final data = d.data() as Map<String, dynamic>;
        return CartItem.fromJson(data);
      }).toList();
    });
  }

  @override
  Future<void> add(Product product, {int quantity = 1}) async {
    final ref = _coll.doc(product.id);
    final doc = await ref.get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final current = CartItem.fromJson(data);
      await ref.set(current.copyWith(quantity: current.quantity + quantity).toJson());
    } else {
      await ref.set(CartItem(product: product, quantity: quantity).toJson());
    }
  }

  @override
  Future<void> remove(String productId) => _coll.doc(productId).delete();

  @override
  Future<void> updateQuantity(String productId, int quantity) async {
    final ref = _coll.doc(productId);
    if (quantity <= 0) {
      await ref.delete();
    } else {
      final doc = await ref.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final current = CartItem.fromJson(data);
        await ref.set(current.copyWith(quantity: quantity).toJson());
      }
    }
  }

  @override
  Future<void> clear() async {
    final batch = FirebaseFirestore.instance.batch();
    final snap = await _coll.get();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}
