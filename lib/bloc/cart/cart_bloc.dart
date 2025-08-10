import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/cart_repository.dart';
import '../../repositories/product_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepo;
  final IProductRepository productRepo;
  StreamSubscription? _sub;

  CartBloc({required this.cartRepo, required this.productRepo}) : super(const CartState()) {
    on<CartStarted>(_onStarted);
    on<CartAddItem>(_onAdd);
    on<CartRemoveItem>(_onRemove);
    on<CartSetQuantity>(_onSetQty);
    on<CartClear>(_onClear);
    on<_CartInternalUpdate>(_onInternalUpdate);
  }

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    await _sub?.cancel();
    _sub = cartRepo.watchCart().listen((items) {
      add(_CartInternalUpdate(items));
    });
  }

  Future<void> _onAdd(CartAddItem event, Emitter<CartState> emit) async {
    final prod = await productRepo.getById(event.productId);
    if (prod != null) await cartRepo.add(prod);
  }

  Future<void> _onRemove(CartRemoveItem event, Emitter<CartState> emit) async {
    await cartRepo.remove(event.productId);
  }

  Future<void> _onSetQty(CartSetQuantity event, Emitter<CartState> emit) async {
    await cartRepo.updateQuantity(event.productId, event.quantity);
  }

  Future<void> _onClear(CartClear event, Emitter<CartState> emit) async {
    await cartRepo.clear();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}

// Evento interno para actualizar estado desde stream
class _CartInternalUpdate extends CartEvent {
  final List items;
  _CartInternalUpdate(this.items);
  @override
  List<Object?> get props => [items];
}

void _onInternalUpdate(_CartInternalUpdate event, Emitter<CartState> emit) {
  emit(CartState(items: List.castFrom(event.items)));
}
