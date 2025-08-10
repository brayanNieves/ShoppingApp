import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {}

class CartAddItem extends CartEvent {
  final String productId;
  CartAddItem(this.productId);
  @override
  List<Object?> get props => [productId];
}

class CartRemoveItem extends CartEvent {
  final String productId;
  CartRemoveItem(this.productId);
  @override
  List<Object?> get props => [productId];
}

class CartSetQuantity extends CartEvent {
  final String productId;
  final int quantity;
  CartSetQuantity(this.productId, this.quantity);
  @override
  List<Object?> get props => [productId, quantity];
}

class CartClear extends CartEvent {}
