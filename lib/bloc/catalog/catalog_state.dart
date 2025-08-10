import 'package:equatable/equatable.dart';
import '../../models/product.dart';

enum CatalogStatus { initial, loading, success, failure }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<Product> products;
  final String? error;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.products = const [],
    this.error,
  });

  CatalogState copyWith({
    CatalogStatus? status,
    List<Product>? products,
    String? error,
  }) => CatalogState(
        status: status ?? this.status,
        products: products ?? this.products,
        error: error,
      );

  @override
  List<Object?> get props => [status, products, error];
}
