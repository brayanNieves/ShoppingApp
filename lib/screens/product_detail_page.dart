import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../repositories/product_repository.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: context.read<IProductRepository>().getById(productId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final p = snapshot.data!;
        return Scaffold(
          appBar: AppBar(title: Text(p.title)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AspectRatio(
                aspectRatio: 3/2,
                child: Image.network(p.imageUrl, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('\$${p.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(p.description),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => context.read<CartBloc>().add(CartAddItem(p.id)),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Agregar al carrito'),
              ),
            ],
          ),
        );
      },
    );
  }
}
