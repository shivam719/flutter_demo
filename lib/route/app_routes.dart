

import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();

  static const onboarding = '/onboarding';
  static const splash = '/splash';
  static const dashboard = '/dashboard';
  static const login = '/login';
  static const signUp = '/signUp';
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

