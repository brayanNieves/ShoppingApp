import 'package:equatable/equatable.dart';
import '../../models/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;
  const CartState({this.items = const []});

  double get total => items.fold(0.0, (sum, i) => sum + i.subtotal);

  @override
  List<Object?> get props => [items, total];
}
