// ignore_for_file: use_build_context_synchronously

import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:counter_credit/service/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _nome = '';
  String _descricao = '';
  double _taxaDeJuros = 0.0;
  double _creditoMinimo = 0.0;
  double _creditoMaximo = 0.0;
  int _prazoMinimo = 0;
  int _prazoMaximo = 0;
  int _carenciaMinima = 0;
  int _carenciaMaxima = 0;
  double? _bonusDia;

  final _creditoFormatter = MaskTextInputFormatter(
    mask: '###.###.###,##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final ProductService productService = ProductService();

      await productService.addProductWithAutoId(Product(
          carenciaMaxima: _carenciaMaxima,
          carenciaMinima: _carenciaMinima,
          createdAt: DateTime.now(),
          creditoMaximo: _creditoMaximo,
          creditoMinimo: _creditoMinimo,
          descricao: _descricao,
          id: '',
          nome: _nome,
          prazoMaximo: _prazoMaximo,
          prazoMinimo: _prazoMinimo,
          taxaDeJuros: _taxaDeJuros,
          updatedAt: DateTime.now(),
          bonusDia: _bonusDia));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto adicionado com sucesso!')),
      );
      Provider.of<ProductListener>(context, listen: false)
          .notifyProductChanges();
      GoRouter.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar produto.')),
      );
    }
  }

  double _parseCurrency(String value) {
    return double.tryParse(value.replaceAll('.', '').replaceAll(',', '.')) ??
        0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Novo Produto'),
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
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome do produto';
                      }
                      return null;
                    },
                    onSaved: (value) => _nome = value!,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    onSaved: (value) => _descricao = value!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Crédito Mínimo'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _creditoMinimo = _parseCurrency(value!),
                    inputFormatters: [_creditoFormatter],
                    validator: (value) {
                      if (value == null || _parseCurrency(value) < 0.0) {
                        return 'Por favor, insira um valor válido';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Crédito Máximo'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _creditoMaximo = _parseCurrency(value!),
                    inputFormatters: [_creditoFormatter],
                    validator: (value) {
                      if (value == null || _parseCurrency(value) == 0.0) {
                        return 'Por favor, insira um valor válido';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Bônus pagamento em dia'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _bonusDia =
                        double.tryParse(value!.replaceAll(',', '.'))!,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      'Salvar Produto',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
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
