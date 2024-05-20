import 'package:counter_credit/screens/admin/add_product_page.dart';
import 'package:counter_credit/screens/admin/admin_home_page.dart';
import 'package:counter_credit/screens/admin/product_details_page.dart';
import 'package:counter_credit/screens/client/home_page.dart';
import 'package:counter_credit/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final router = GoRouter(
  redirect: (context, state) {
    final loggedIn = Supabase.instance.client.auth.currentUser != null;
    final goingToLogin = state.fullPath == '/login';

    if (!loggedIn && !goingToLogin && state.fullPath != '/') {
      return '/login';
    }
    if (loggedIn && goingToLogin) {
      return '/admin';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const CreditSimulatorScreen(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) =>
              const LoginPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePageAdmin();
      },
      routes: [
        GoRoute(
          path: 'product-details/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return ProductDetailPage(productId: id ?? '');
          },
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) {
            return const AddProductPage();
          },
        ),
      ],
    ),
  ],
);
