import 'package:chat_app/pages/homepage.dart';
import 'package:chat_app/pages/loginpage.dart';
import 'package:chat_app/pages/registerpage.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> navigatorKey;
  final Map<String, Widget Function(BuildContext)> routes = {
    "/login": (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    "/register": (context) => const RegisterPage(),
  };

  GlobalKey<NavigatorState>? get nav {
    return navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get route {
    return routes;
  }

  NavigationService() {
    navigatorKey = GlobalKey<NavigatorState>();
  }

  void pushNamed(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }
  void pushReplacementNamed (String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }
  void goback (){
    navigatorKey.currentState?.pop();
  }
}
