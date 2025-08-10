import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/catalog/catalog_bloc.dart';
import '../bloc/catalog/catalog_event.dart';
import '../bloc/catalog/catalog_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../core/app_router.dart';
import '../widgets/product_card.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(CatalogRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRouter.cart),
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.status == CatalogStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CatalogStatus.failure) {
            return Center(child: Text('Error: ${state.error}'));
          }
          final products = state.products;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return ProductCard(
                product: p,
                onTap: () => Navigator.pushNamed(context, AppRouter.detail, arguments: p.id),
                onAdd: () => context.read<CartBloc>().add(CartAddItem(p.id)),
              );
            },
          );
        },
      ),
    );
  }
}
