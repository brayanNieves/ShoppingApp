import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppingapp/features/products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final FirebaseFirestore firestore;

  CartRepositoryImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _itemsCol(String uid) =>
      firestore.collection('carts').doc(uid).collection('items');

  @override
  Stream<List<CartItem>> watchCart(String uid) {
    return _itemsCol(uid)
        .snapshots()
        .map((qs) => qs.docs.map((doc) {
              final data = doc.data();
              final quantity = (data['quantity'] as int?) ?? 0;
              final productMap = data['product'] as Map<String, dynamic>?;
              final product = productMap != null
                  ? Product(
                      id: productMap['id'] as String,
                      name: productMap['name'] as String,
                      description: productMap['description'] as String,
                      price: (productMap['price'] as num).toDouble(),
                      imageUrl: productMap['imageUrl'] as String,
                    )
                  : Product(id: doc.id, name: '', description: '', price: 0, imageUrl: '');
              return CartItem(product: product, quantity: quantity);
            }).toList());
  }

  @override
  Future<void> add(String uid, Product product, {int quantity = 1}) async {
    final doc = _itemsCol(uid).doc(product.id);
    await firestore.runTransaction((tx) async {
      final snap = await tx.get(doc);
      if (snap.exists) {
        final current = (snap.data()?['quantity'] ?? 0) as int;
        tx.update(doc, {
          'quantity': current + quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        tx.set(doc, {
          'quantity': quantity,
          'product': {
            'id': product.id,
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  @override
  Future<void> remove(String uid, String productId) async {
    await _itemsCol(uid).doc(productId).delete();
  }

  @override
  Future<void> updateQuantity(String uid, String productId, int quantity) async {
    final doc = _itemsCol(uid).doc(productId);
    if (quantity <= 0) {
      await doc.delete();
      return;
    }
    await doc.update({'quantity': quantity, 'updatedAt': FieldValue.serverTimestamp()});
  }

  @override
  Future<void> clear(String uid) async {
    final qs = await _itemsCol(uid).get();
    final batches = <WriteBatch>[];
    WriteBatch batch = firestore.batch();
    int ops = 0;
    for (final d in qs.docs) {
      batch.delete(d.reference);
      ops++;
      if (ops == 450) {
        batches.add(batch);
        batch = firestore.batch();
        ops = 0;
      }
    }
    batches.add(batch);
    for (final b in batches) {
      await b.commit();
    }
  }
}
