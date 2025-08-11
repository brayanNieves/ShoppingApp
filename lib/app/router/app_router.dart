import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shoppingapp/features/auth/presentation/pages/login_page.dart';
import 'package:shoppingapp/features/products/presentation/pages/product_detail_page.dart';
import 'package:shoppingapp/features/products/presentation/pages/restaurant_screen.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.toString();
      final authState = authBloc.state;
      final loggingIn = location == '/sign-in';
      if (authState is! AuthAuthenticated) {
        return loggingIn ? null : '/login';
      }
      if (loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (ctx, st) => const RestaurantScreen(),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (ctx, st) => const SignInPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (ctx, st) => const LoginPage(),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (ctx, st) {
          final id = st.pathParameters['id']!;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (ctx, st) => const CartPage(),
      ),
    ],
    errorBuilder: (ctx, st) => Scaffold(
      body: Center(child: Text('Ruta no encontrada: ${st.error}')),
    ),
  );
}

