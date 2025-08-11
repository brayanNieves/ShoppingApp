import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shoppingapp/app/widgets/reusable_widgets.dart';
import 'package:shoppingapp/core/utils/utils.dart';
import 'package:shoppingapp/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shoppingapp/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shoppingapp/features/products/domain/entities/product.dart';
import 'package:shoppingapp/features/products/presentation/bloc/catalog_bloc.dart';

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(CartStarted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HeaderAppBar(),
          SliverToBoxAdapter(child: _RestaurantHeader()),
          BlocBuilder<CatalogBloc, CatalogState>(
            builder: (context, state) {
              if (state is CatalogLoading) {
                return SliverToBoxAdapter(
                  child: const Center(child: CircularProgressIndicator()),
                );
              }
              if (state is CatalogFailure) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('Error: ${state.message}')),
                );
              }
              final items = (state as CatalogLoaded).products;
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .74,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: items.length,
                  itemBuilder:
                      (context, i) => ProductCard(
                        product: items[i],
                        onTap: () => context.push('/product/${items[i].id}'),
                        onTapAdd: () {
                          context.read<CartBloc>().add(
                            CartItemAdded(items[i], quantity: 1),
                          );
                        },
                      ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
        ],
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const SizedBox.shrink();
          }
          if (state is CartFailure) {
            return const SizedBox.shrink();
          }
          final items = (state as CartLoaded).items;
          if (items.isEmpty) {
            return const SizedBox.shrink();
          }
          final total = items.fold<double>(0, (s, it) => s + it.total);
          return Padding(
            padding: const EdgeInsets.all(22.0),
            child: BuildCustomButton(
              text: 'Ver carrito ${Utils.getNumberFormat(total)}',
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () => context.push('/cart'),
            ),
          );
        },
      ),
    );
  }
}

class _HeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      expandedHeight: 220,
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return CircleIconButton(
                onTap: () {
                  context.read<AuthBloc>().add(AuthSignOut());
                  context.go('/login');
                },
                icon: Icons.login,
              );
            }
            return CircleIconButton(
              onTap: () => context.go('/login'),
              icon: Icons.login,
            );
          },
        ),
        SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://qz.com/cdn-cgi/image/width=1920,quality=85,format=auto/https://assets.qz.com/media/9317d132ad99c17439e8f9a905dc9414.jpg',
              fit: BoxFit.cover,
            ),
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

class _RestaurantHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.white,
                  width: 48,
                  height: 48,
                  child: Center(
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1uyt5qfW-jEBJN38D7nfAXzpbT7f4-kA-hA&s',
                      width: 36,
                      height: 36,
                      errorBuilder:
                          (_, __, ___) =>
                              const Icon(Icons.restaurant, size: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'MacDonal\'s Nuñez',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final GestureTapCallback? onTap;
  final VoidCallback? onTapAdd;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onTapAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Positioned(
                        //   top: 10,
                        //   right: 10,
                        //   child: CircleIconButton(
                        //     icon: Icons.favorite_border,
                        //     size: 36,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    product.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Text(
                        Utils.getNumberFormat(product.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const Spacer(),
                      CircleIconButton(icon: Icons.add, onTap: onTapAdd),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
