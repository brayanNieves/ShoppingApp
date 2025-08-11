import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shoppingapp/features/products/presentation/bloc/catalog_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/cart/presentation/bloc/cart_bloc.dart';
import 'di/injector.dart';
import 'router/app_router.dart';

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  final sl = GetIt.I;

  @override
  void initState() {
    super.initState();
    initDI();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = sl<AuthBloc>()..add(AuthStarted());
    GoRouter router = createRouter(authBloc);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(AuthStarted())),
        BlocProvider(create: (_) => sl<CatalogBloc>()..add(CatalogStarted())),
        BlocProvider(create: (_) => sl<CartBloc>()..add(CartStarted())),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Shopping App',
        theme: ThemeData(colorSchemeSeed: Colors.teal),
        routerConfig: router,
      ),
    );
  }
}
