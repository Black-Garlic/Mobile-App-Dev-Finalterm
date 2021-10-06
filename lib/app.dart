import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'signup.dart';
import 'detail.dart';
import 'search.dart';
import 'favorite.dart';
import 'mypage.dart';
import './model/product.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrine',
      home: const HomePage(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/sign up': (context) => const SignUpPage(),
        '/search': (context) => const SearchPage(),
        '/favorite': (context) => const FavoritePage(),
        '/my page': (context) => const MyPage(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == '/detail') {
          final product = routeSettings.arguments as Product;
          return MaterialPageRoute(
            builder: (context) {
              return DetailPage(
                id: product.id,
              );
            }
          );
        }
      },
    );
  }

  Route<dynamic>? _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => const LoginPage(),
      fullscreenDialog: true,
    );
  }
}
