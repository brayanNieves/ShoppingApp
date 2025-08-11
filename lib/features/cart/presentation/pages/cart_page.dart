import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shoppingapp/app/extensions/extensions.dart';
import 'package:shoppingapp/app/widgets/reusable_widgets.dart';
import 'package:shoppingapp/core/utils/utils.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        actions: [
          IconButton(
            onPressed: () => context.read<CartBloc>().add(CartCleared()),
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }
          final items = (state as CartLoaded).items;
          if (items.isEmpty) {
            return const Center(child: Text('Tu carrito está vacío'));
          }
          final total = items.fold<double>(0, (s, it) => s + it.total);
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (ctx, i) {
                    final it = items[i];
                    return _CartTile(item: it);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(22.0),
                child: BuildCustomButton(
                  text: 'Enviar orden ${Utils.getNumberFormat(total)}',
                  color: Colors.red,
                  width: double.infinity,
                  onPressed: () {
                    context.read<CartBloc>().add(CartCleared());
                    context.showSnackBar('Orden enviada');
                    context.pop();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  final CartItem item;

  const _CartTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        item.product.imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
      title: Text(item.product.name),
      subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed:
                () => context.read<CartBloc>().add(
                  CartItemQuantityChanged(item.product.id, item.quantity - 1),
                ),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text('${item.quantity}'),
          IconButton(
            onPressed:
                () => context.read<CartBloc>().add(
                  CartItemQuantityChanged(item.product.id, item.quantity + 1),
                ),
            icon: const Icon(Icons.add_circle_outline),
          ),
          IconButton(
            onPressed:
                () => context.read<CartBloc>().add(
                  CartItemRemoved(item.product.id),
                ),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}
