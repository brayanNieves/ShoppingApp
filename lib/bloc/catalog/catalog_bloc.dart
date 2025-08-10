import 'package:flutter_bloc/flutter_bloc.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';
import '../../repositories/product_repository.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final IProductRepository repo;
  CatalogBloc(this.repo) : super(const CatalogState()) {
    on<CatalogRequested>(_onRequested);
  }

  Future<void> _onRequested(CatalogRequested event, Emitter<CatalogState> emit) async {
    emit(state.copyWith(status: CatalogStatus.loading));
    try {
      final products = await repo.fetchProducts();
      emit(state.copyWith(status: CatalogStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: CatalogStatus.failure, error: e.toString()));
    }
  }
}
