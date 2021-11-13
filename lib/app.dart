import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'model/item.dart';
import 'signup.dart';
import 'detail.dart';
import 'add.dart';
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
        '/add': (context) => const AddPage(),
        '/favorite': (context) => const FavoritePage(),
        '/my page': (context) => const MyPage(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == '/detail') {
          int id = routeSettings.arguments as int;
          return MaterialPageRoute(
            builder: (context) {
              return DetailPage(
                id: id,
              );
            }
          );
        }
        return null;
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
