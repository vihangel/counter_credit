import 'dart:developer';

import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:counter_credit/screens/admin/widget/product_listtile_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  HomePageAdminState createState() => HomePageAdminState();
}

class HomePageAdminState extends State<HomePageAdmin> {
  final List<Product> _products = [];
  final _supabaseClient = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    final productListener =
        Provider.of<ProductListener>(context, listen: false);
    productListener.addListener(_fetchProducts);
    _fetchProducts();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchProducts() async {
    try {
      final List<Product> products = [];
      final productResponse = await _supabaseClient.from('produtos').select();

      for (var p in productResponse) {
        Product product = Product.fromJson(p);

        products.add(product);
      }

      setState(() {
        _products.clear();
        _products.addAll(products);
      });
    } catch (e) {
      log('Error fetching products: $e');
    }
  }

  void showDialogDelete(int productId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Deletar Produto'),
          content: const Text('Tem certeza que deseja deletar?'),
          actions: [
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
                _deleteProduct(productId);
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int productId) async {
    final response = await _supabaseClient
        .from('produtos')
        .delete()
        .match({'id': productId});

    if (response == null) {
      _fetchProducts();
    } else {
      log('Error deleting product: ${response}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/conecta.png',
          height: 100,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                _fetchProducts();
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                GoRouter.of(context).go('/admin/add');
              },
              icon: const Icon(Icons.add)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Supabase.instance.client.auth.signOut();
              GoRouter.of(context).go('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ProductListTileButton(
                onPressed: () {
                  GoRouter.of(context)
                      .go('/admin/product-details/${product.id}');
                },
                icon: Icons.calculate,
                name: product.nome,
                description: product.descricao,
                onDelete: () => showDialogDelete(product.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
