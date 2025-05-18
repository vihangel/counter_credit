import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:counter_credit/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EditProductPage extends StatefulWidget {
  final String productId;

  const EditProductPage({super.key, required this.productId});

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();

  Product? _product;

  late String _nome;
  late String _descricao;
  late double _taxaDeJuros;
  late double _creditoMinimo;
  late double _creditoMaximo;
  late int _prazoMinimo;
  late int _prazoMaximo;
  late int _carenciaMinima;
  late int _carenciaMaxima;
  late double? _bonusDia;

  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  void _fetchProduct() async {
    try {
      final product = await _productService.getProduct(widget.productId);
      setState(() {
        _product = product;
        _nome = product.nome;
        _descricao = product.descricao;
        _taxaDeJuros = product.taxaDeJuros;
        _creditoMinimo = product.creditoMinimo;
        _creditoMaximo = product.creditoMaximo;
        _prazoMinimo = product.prazoMinimo;
        _prazoMaximo = product.prazoMaximo;
        _carenciaMinima = product.carenciaMinima;
        _carenciaMaxima = product.carenciaMaxima;
        _bonusDia = product.bonusDia;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar produto.')),
      );
    }
  }

  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ??
        0.0;
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _productService.updateProduct(
          Product(
            id: widget.productId,
            nome: _nome,
            descricao: _descricao,
            taxaDeJuros: _taxaDeJuros,
            creditoMinimo: _creditoMinimo,
            creditoMaximo: _creditoMaximo,
            prazoMinimo: _prazoMinimo,
            prazoMaximo: _prazoMaximo,
            carenciaMinima: _carenciaMinima,
            carenciaMaxima: _carenciaMaxima,
            bonusDia: _bonusDia,
            createdAt: _product!.createdAt,
            updatedAt: DateTime.now(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );
        Provider.of<ProductListener>(context, listen: false)
            .notifyProductChanges();
        GoRouter.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar produto.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Produto'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    initialValue: _nome,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    onSaved: (value) => _nome = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do produto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _descricao,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    onSaved: (value) => _descricao = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _taxaDeJuros.toString().replaceAll('.', ','),
                    decoration: const InputDecoration(
                        labelText: 'Taxa de Juros anual(%), ex:15,658'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _taxaDeJuros =
                        double.tryParse(value!.replaceAll(',', '.'))!,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Por favor, insira uma taxa de juros válida';
                      }
                      if (value.contains('.')) {
                        return 'Não use caracteres especiais';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _creditoMinimo.toStringAsFixed(2),
                    decoration:
                        const InputDecoration(labelText: 'Crédito Mínimo'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _creditoMinimo = _parseCurrency(value!),
                    validator: (value) {
                      if (double.tryParse(value!
                              .replaceAll('.', '')
                              .replaceAll(',', '.')) ==
                          null) {
                        return 'Por favor, insira um valor válido';
                      }
                      if (_parseCurrency(value) < 0.0) {
                        return 'Por favor, insira um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _creditoMaximo.toStringAsFixed(2),
                    decoration:
                        const InputDecoration(labelText: 'Crédito Máximo'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _creditoMaximo = _parseCurrency(value!),
                    validator: (value) {
                      if (double.tryParse(value!
                              .replaceAll('.', '')
                              .replaceAll(',', '.')) ==
                          null) {
                        return 'Por favor, insira um valor válido';
                      }
                      if (_parseCurrency(value) == 0.0) {
                        return 'Por favor, insira um valor válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _prazoMinimo.toString(),
                    decoration: const InputDecoration(
                        labelText: 'Prazo Mínimo (meses)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _prazoMinimo = int.parse(value ?? '0'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value != null && int.tryParse(value) == null) {
                        return 'Por favor, insira um número de meses válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _prazoMaximo.toString(),
                    decoration: const InputDecoration(
                        labelText: 'Prazo Máximo (meses)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _prazoMaximo = int.parse(value ?? '0'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value != null && int.tryParse(value) == null) {
                        return 'Por favor, insira um número de meses válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _carenciaMinima.toString(),
                    decoration: const InputDecoration(
                        labelText: 'Carência Mínima (meses)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _carenciaMinima = int.parse(value ?? '0'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value != null && int.tryParse(value) == null) {
                        return 'Por favor, insira um número de meses válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _carenciaMaxima.toString(),
                    decoration: const InputDecoration(
                        labelText: 'Carência Máxima (meses)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _carenciaMaxima = int.parse(value ?? '0'),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (value) {
                      if (value != null && int.tryParse(value) == null) {
                        return 'Por favor, insira um número de meses válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _bonusDia?.toString().replaceAll('.', ','),
                    decoration: const InputDecoration(
                        labelText: 'Bônus pagamento em dia'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _bonusDia =
                        double.tryParse(value!.replaceAll(',', '.'))!,
                    validator: (value) {
                      if (value == null ||
                          double.tryParse(value.replaceAll(',', '.')) == null) {
                        return 'Por favor, insira um desconto válido';
                      }
                      if (value.contains('.')) {
                        return 'Não use caracteres especiais';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProduct,
                    child: const Text(
                      'Salvar Alterações',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
