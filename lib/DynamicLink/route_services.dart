
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:near_me/Screen/TabPage/HomePage.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/homepage':
        return CupertinoPageRoute(builder: (_) {
          return  HomePage(structure: '', nomeCognome: '',);
        });
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
