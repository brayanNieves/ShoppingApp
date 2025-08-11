import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoppingapp/features/products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

abstract class CartEvent {}

class CartStarted extends CartEvent {}

class CartItemAdded extends CartEvent {
  final Product product;
  final int quantity;

  CartItemAdded(this.product, {this.quantity = 1});
}

class CartItemQuantityChanged extends CartEvent {
  final String productId;
  final int quantity;

  CartItemQuantityChanged(this.productId, this.quantity);
}

class CartItemRemoved extends CartEvent {
  final String productId;

  CartItemRemoved(this.productId);
}

class CartCleared extends CartEvent {}

class _CartItemsUpdated extends CartEvent {
  final List<CartItem> items;

  _CartItemsUpdated(this.items);
}

class _CartAuthChanged extends CartEvent {
  final UserEntity? user;

  _CartAuthChanged(this.user);
}

abstract class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;

  CartLoaded(this.items);
}

class CartFailure extends CartState {
  final String message;

  CartFailure(this.message);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;
  final AuthBloc authBloc;
  StreamSubscription? _cartSub;
  StreamSubscription? _authSub;
  String? _uid;

  CartBloc({required this.cartRepository, required this.authBloc})
    : super(CartLoading()) {
    on<CartStarted>(_onStarted);
    on<CartItemAdded>(_onAdded);
    on<CartItemQuantityChanged>(_onQty);
    on<CartItemRemoved>(_onRemoved);
    on<CartCleared>(_onCleared);
    on<_CartItemsUpdated>(_onItemsUpdated);
    on<_CartAuthChanged>(_onAuthChanged);
  }

  Future<void> _onStarted(CartStarted e, Emitter<CartState> emit) async {
    emit(CartLoading());
    await _authSub?.cancel();
    final currentState = authBloc.state;
    if (currentState is AuthAuthenticated) {
      add(_CartAuthChanged(currentState.user));
    } else {
      add(_CartAuthChanged(null));
    }
    _authSub = authBloc.stream.listen((state) {
      if (state is AuthAuthenticated) {
        add(_CartAuthChanged(state.user));
      } else {
        add(_CartAuthChanged(null));
      }
    });
  }

  void _startCartStream(String uid, Emitter<CartState> emit) {
    _cartSub?.cancel();
    _cartSub = cartRepository
        .watchCart(uid)
        .listen(
          (items) => add(_CartItemsUpdated(items)),
          onError: (e) => emit(CartFailure(e.toString())),
        );
  }

  Future<void> _onAdded(CartItemAdded e, Emitter<CartState> emit) async {
    if (_uid == null) return;
    await cartRepository.add(_uid!, e.product, quantity: e.quantity);
  }

  Future<void> _onQty(
    CartItemQuantityChanged e,
    Emitter<CartState> emit,
  ) async {
    if (_uid == null) return;
    await cartRepository.updateQuantity(_uid!, e.productId, e.quantity);
  }

  Future<void> _onRemoved(CartItemRemoved e, Emitter<CartState> emit) async {
    if (_uid == null) return;
    await cartRepository.remove(_uid!, e.productId);
  }

  Future<void> _onCleared(CartCleared e, Emitter<CartState> emit) async {
    if (_uid == null) return;
    await cartRepository.clear(_uid!);
  }

  void _onItemsUpdated(_CartItemsUpdated e, Emitter<CartState> emit) {
    emit(CartLoaded(e.items));
  }

  void _onAuthChanged(_CartAuthChanged e, Emitter<CartState> emit) {
    _uid = e.user?.uid;
    if (_uid == null) {
      emit(CartLoaded(const []));
      _cartSub?.cancel();
    } else {
      _startCartStream(_uid!, emit);
    }
  }

  @override
  Future<void> close() {
    _cartSub?.cancel();
    _authSub?.cancel();
    return super.close();
  }
}
