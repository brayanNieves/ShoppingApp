import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/products_repository.dart';

abstract class CatalogEvent {}

class CatalogStarted extends CatalogEvent {}

class CatalogRefreshed extends CatalogEvent {}

abstract class CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Product> products;

  CatalogLoaded(this.products);
}

class CatalogFailure extends CatalogState {
  final String message;

  CatalogFailure(this.message);
}

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ProductsRepository productsRepository;

  CatalogBloc({required this.productsRepository}) : super(CatalogLoading()) {
    on<CatalogStarted>(_onStart);
    on<CatalogRefreshed>(_onStart);
  }

  Future<void> _onStart(CatalogEvent e, Emitter<CatalogState> emit) async {
    emit(CatalogLoading());
    try {
      final items = await productsRepository.getProducts();
      emit(CatalogLoaded(items));
    } catch (err) {
      emit(CatalogFailure(err.toString()));
    }
  }
}
