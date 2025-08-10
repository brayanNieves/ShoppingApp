import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/cart/cart_event.dart';
import '../bloc/cart/cart_state.dart';
import '../widgets/quantity_stepper.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carrito')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text('Tu carrito está vacío'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: state.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = state.items[i];
                    return ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(item.product.imageUrl)),
                      title: Text(item.product.title),
                      subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          QuantityStepper(
                            value: item.quantity,
                            onIncrement: () => context.read<CartBloc>().add(
                                  CartSetQuantity(item.product.id, item.quantity + 1),
                                ),
                            onDecrement: () => context.read<CartBloc>().add(
                                  CartSetQuantity(item.product.id, item.quantity - 1),
                                ),
                          ),
                          Text('Subt: \$${item.subtotal.toStringAsFixed(2)}'),
                        ],
                      ),
                      onLongPress: () =>
                          context.read<CartBloc>().add(CartRemoveItem(item.product.id)),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: Theme.of(context).textTheme.titleLarge),
                    Text('\$${state.total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: () => context.read<CartBloc>().add(CartClear()),
            child: const Text('Vaciar carrito'),
          ),
        ),
      ),
    );
  }
}
