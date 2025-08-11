import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppingapp/app/widgets/reusable_widgets.dart';
import 'package:shoppingapp/core/utils/utils.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../domain/entities/product.dart';
import '../../presentation/bloc/catalog_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is! CatalogLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = state.products.firstWhere((e) => e.id == productId);
          return CustomScrollView(
            slivers: [
              _HeaderAppBar(photo: product.imageUrl),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product.description),
                      const SizedBox(height: 16),
                      Text(
                        Utils.getNumberFormat(product.price),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is! CatalogLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          final product = state.products.firstWhere((e) => e.id == productId);
          return Padding(
            padding: const EdgeInsets.all(22.0),
            child: BuildCustomButton(
              onPressed: () {
                context.read<CartBloc>().add(
                  CartItemAdded(product, quantity: 1),
                );
                Navigator.maybePop(context);
              },
              text: 'Agregar al carrito',
            ),
          );
        },
      ),
    );
  }
}

class _HeaderAppBar extends StatelessWidget {
  final String photo;

  const _HeaderAppBar({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      expandedHeight: 220,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: CircleIconButton(
          icon: Icons.arrow_back,
          onTap: () => Navigator.maybePop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(photo, fit: BoxFit.cover),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Colors.black54, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
