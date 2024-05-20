import 'package:counter_credit/models/simulate.dart';
import 'package:counter_credit/screens/admin/add_product_page.dart';
import 'package:counter_credit/screens/admin/admin_home_page.dart';
import 'package:counter_credit/screens/admin/product_details_page.dart';
import 'package:counter_credit/screens/client/home_page.dart';
import 'package:counter_credit/screens/client/simulate_page.dart';
import 'package:counter_credit/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  redirect: (context, state) {
    final loggedIn = Supabase.instance.client.auth.currentUser != null;
    final goingToLogin = state.fullPath == '/login';

    if ((state.fullPath == '/' || state.fullPath == '/simulacao')) {
      return null;
    }

    if (!loggedIn &&
        !goingToLogin &&
        (state.fullPath != '/' || state.fullPath != '/simulacao')) {
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
        GoRoute(
          path: 'simulacao',
          redirect: (context, state) => state.extra == null ? '/' : null,
          builder: (context, state) {
            final simulate = state.extra as Simulate;

            return SimulatePage(
              simulate: simulate,
              payment: simulate.prazoPagamento.toString(),
              credit: simulate.valorFinanciamento.toString(),
              gracePeriod: simulate.carenciaMeses.toString(),
            );
          },
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
