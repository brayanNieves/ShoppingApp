import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoppingapp/features/products/data/repositories/products_repository_impl.dart';
import 'package:shoppingapp/features/products/domain/repositories/products_repository.dart';
import 'package:shoppingapp/features/products/presentation/bloc/catalog_bloc.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';

final getIt = GetIt.I;

void initDI() {
  bool isRegistered = getIt.isRegistered<FirebaseAuth>();
  if (isRegistered) return;

  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(auth: getIt()),
  );

  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(authRepository: getIt()),
  );

  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(firestore: getIt()),
  );
  getIt.registerFactory(() => CatalogBloc(productsRepository: getIt()));

  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(firestore: getIt()),
  );

  getIt.registerLazySingleton<CartBloc>(
    () => CartBloc(cartRepository: getIt(), authBloc: getIt()),
  );
}
