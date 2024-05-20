import 'package:counter_credit/firebase_options.dart';
import 'package:counter_credit/routes/setup_routes.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  Supabase.initialize(
    url: 'https://ewgwmdmqzgdumpxjohac.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3Z3dtZG1xemdkdW1weGpvaGFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU4OTA5OTYsImV4cCI6MjAzMTQ2Njk5Nn0.APbCJc1yAnSRIMW2CkKrh-KuvyxfCn3lfgTl0_V7ZY0',
  );
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ProductListener(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const MaterialColor(
            0xFF20124d,
            <int, Color>{},
          ),
          primary: const Color(0xFF20124d),
          secondary: const Color.fromARGB(255, 229, 239, 230),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF20124d),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
