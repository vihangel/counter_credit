// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:counter_credit/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Product? _product;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  void _fetchProduct() async {
    try {
      final Product product = await productService.getProduct(widget.productId);

      setState(() {
        _product = product;
      });
    } catch (e) {
      log('Error fetching product: $e');
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
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
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
                          _deleteProduct(_product!.id);
                        },
                        child: const Text('Deletar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: _product == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        title: const Text('Nome'),
                        subtitle: Text(_product!.nome),
                      ),
                      ListTile(
                        title: const Text('Descrição'),
                        subtitle: Text(_product!.descricao),
                      ),
                      ListTile(
                        title: const Text('Taxa de Juros'),
                        subtitle: Text(_product!.taxaDeJuros.toString()),
                      ),
                      ListTile(
                        title: const Text('Crédito Mínimo'),
                        subtitle: Text(_product!.creditoMinimo.toString()),
                      ),
                      ListTile(
                        title: const Text('Crédito Máximo'),
                        subtitle: Text(_product!.creditoMaximo.toString()),
                      ),
                      ListTile(
                        title: const Text('Prazo Mínimo'),
                        subtitle: Text(_product!.prazoMinimo.toString()),
                      ),
                      ListTile(
                        title: const Text('Prazo Máximo'),
                        subtitle: Text(_product!.prazoMaximo.toString()),
                      ),
                      ListTile(
                        title: const Text('Carência Mínima'),
                        subtitle: Text(_product!.carenciaMinima.toString()),
                      ),
                      ListTile(
                        title: const Text('Carência Máxima'),
                        subtitle: Text(_product!.carenciaMaxima.toString()),
                      ),
                      ListTile(
                        title: const Text('Bônus Dia'),
                        subtitle: Text(_product!.bonusDia?.toString() ?? 'N/A'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  final productService = ProductService();

  void _deleteProduct(String productId) async {
    try {
      await productService.deleteProduct(productId);

      Provider.of<ProductListener>(context, listen: false)
          .notifyProductChanges();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto deletado com sucesso!'),
        ),
      );
      GoRouter.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao deletar produto'),
        ),
      );
      log('Error deleting product: ${e}');
    }
  }
}
