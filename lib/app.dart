import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/cart/cart_event.dart';
import 'bloc/catalog/catalog_bloc.dart';
import 'repositories/cart_repository.dart';
import 'repositories/product_repository.dart';
import 'core/app_router.dart';
import 'screens/catalog_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/cart_page.dart';
import 'screens/sign_in_page.dart';

class App extends StatelessWidget {
  final IProductRepository productRepository;
  final ICartRepository cartRepository;

  const App({
    super.key,
    required this.productRepository,
    required this.cartRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<IProductRepository>.value(value: productRepository),
        RepositoryProvider<ICartRepository>.value(value: cartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CatalogBloc(productRepository)),
          BlocProvider(create: (_) => CartBloc(cartRepo: cartRepository, productRepo: productRepository)..add(CartStarted())),
        ],
        child: MaterialApp(
          title: 'APP Tiendas',
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
          initialRoute: AppRouter.catalog,
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case AppRouter.catalog:
                return MaterialPageRoute(builder: (_) => const CatalogPage());
              case AppRouter.detail:
                final productId = settings.arguments as String;
                return MaterialPageRoute(builder: (_) => ProductDetailPage(productId: productId));
              case AppRouter.cart:
                return MaterialPageRoute(builder: (_) => const CartPage());
              case AppRouter.signIn:
                return MaterialPageRoute(builder: (_) => const SignInPage());
              default:
                return MaterialPageRoute(builder: (_) => const CatalogPage());
            }
          },
        ),
      ),
    );
  }
}
