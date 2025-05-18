import 'dart:developer';

import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:counter_credit/screens/admin/widget/product_listtile_button.dart';
import 'package:counter_credit/service/product_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({super.key});

  @override
  HomePageAdminState createState() => HomePageAdminState();
}

class HomePageAdminState extends State<HomePageAdmin> {
  final List<Product> _products = [];

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

  final ProductService productService = ProductService();
  void _fetchProducts() async {
    try {
      final List<Product> products = await productService.getProducts();
      setState(() {
        _products.clear();
        _products.addAll(products);
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao buscar produtos, atualize a página!'),
        ),
      );
      log('Error fetching products: $e');
    }
  }

  void showDialogDelete(String productId) {
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
              onPressed: () async {
                _deleteProduct(productId);
                GoRouter.of(context).pop();
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await productService.deleteProduct(productId);

      _fetchProducts();
    } catch (e) {
      log('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao remover o produto, atualize a página!'),
        ),
      );
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
              FirebaseAuth.instance.signOut();
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
                onEdit: () {
                  GoRouter.of(context).go('/admin/edit-product/${product.id}');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
