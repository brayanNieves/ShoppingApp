import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final FirebaseFirestore firestore;

  ProductsRepositoryImpl({required this.firestore});

  final _items = <Product>[
    Product(
      id: '1',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
    Product(
      id: '2',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
    Product(
      id: '2',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
    Product(
      id: '3',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
    Product(
      id: '4',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
    Product(
      id: '5',
      name: 'Shawarma de res con falafel',
      description: 'Res · Falafel',
      price: 525,
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=1600&auto=format&fit=crop',
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    final QuerySnapshot products = await firestore.collection('products').get();
    if (products.docs.isNotEmpty) {
      return products.docs
          .map(
            (e) => Product(
              id: e.get('id'),
              name: e.get('name'),
              description: e.get('desc'),
              price: num.tryParse(e.get('price')) ?? 0,
              imageUrl: e.get('photo'),
            ),
          )
          .toList();
    }
    return [];
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
