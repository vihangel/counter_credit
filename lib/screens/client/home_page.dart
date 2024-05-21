import 'dart:developer';

import 'package:counter_credit/models/simulate.dart';
import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:counter_credit/screens/admin/widget/slider_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreditSimulatorScreen extends StatefulWidget {
  const CreditSimulatorScreen({super.key});

  @override
  CreditSimulatorScreenState createState() => CreditSimulatorScreenState();
}

class CreditSimulatorScreenState extends State<CreditSimulatorScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Product> _products = [];
  Product? _selectedProduct;
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();
  final TextEditingController _gracePeriodController = TextEditingController();

  double _minCredit = 0;
  double _maxCredit = 10000;
  double _minPayment = 0;
  double _maxPayment = 12;
  double _minGrace = 0;
  double _maxGrace = 12;

  Simulate? simulate;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onLongPress: () {
            GoRouter.of(context).go('/login');
          },
          child: Image.asset(
            'assets/conecta.png',
            height: 100,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Product>(
                    isExpanded: true,
                    value: _selectedProduct,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration:
                        const InputDecoration(labelText: 'Escolha o Produto'),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedProduct = newValue!;
                        _creditController.clear();
                        _paymentController.clear();
                        _gracePeriodController.clear();
                        _updateProductSettings();
                      });
                    },
                    items: _products.map<DropdownMenuItem<Product>>((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Text(product.nome),
                      );
                    }).toList(),
                    validator: (value) =>
                        value == null ? 'Este campo é obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  SliderTextField(
                    key: Key(
                        'credit+$_minCredit+$_maxCredit+${_selectedProduct?.nome}'),
                    labelText: 'Valor do Crédito',
                    min: _minCredit,
                    max: _maxCredit,
                    isDecimal: true,
                    controller: _creditController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório';
                      }
                      if (textToDouble(_creditController.text) > _maxCredit) {
                        return 'O crédito deve ser menor que $_maxCredit';
                      }
                      if (textToDouble(_creditController.text) < _minCredit) {
                        return 'O crédito deve ser maior que $_minCredit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SliderTextField(
                    key: Key(
                        'payment+$_minPayment+$_maxPayment+${_selectedProduct?.nome}'),
                    labelText: 'Prazo de Pagamento (meses)',
                    min: _minPayment,
                    max: _maxPayment,
                    controller: _paymentController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório';
                      }
                      if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Apenas números são permitidos';
                      }
                      if (textToDouble(_paymentController.text) < _minPayment) {
                        return 'O prazo de pagamento deve ser maior que $_minPayment';
                      }
                      if (textToDouble(_paymentController.text) > _maxPayment) {
                        return 'O prazo de pagamento deve ser menor que $_maxPayment';
                      }
                      if (textToDouble(_paymentController.text) <
                              textToDouble(_gracePeriodController.text) &&
                          _gracePeriodController.text.isNotEmpty) {
                        return 'O prazo de pagamento deve ser maior\nque o prazo de carência';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SliderTextField(
                    key: Key(
                        'gracePeriod+$_minGrace+$_maxGrace+${_selectedProduct?.nome}'),
                    labelText: 'Prazo de Carência (meses)',
                    min: _minGrace,
                    max: _maxGrace,
                    controller: _gracePeriodController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório';
                      }
                      if (textToDouble(_gracePeriodController.text) <
                          _minGrace) {
                        return 'O prazo de carência deve ser maior que $_minGrace';
                      }
                      if (textToDouble(_gracePeriodController.text) >
                          _maxGrace) {
                        return 'O prazo de carência deve ser menor que $_maxGrace';
                      }
                      if (textToDouble(_gracePeriodController.text) >=
                          textToDouble(_paymentController.text)) {
                        return 'O prazo de carência deve ser menor\nque o prazo de pagamento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _simulateInstallments();
                      }
                    },
                    child: const Text(
                      'Simular Parcelas',
                      style: TextStyle(
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao buscar produtosm, atualize a página!'),
        ),
      );
      log('Error fetching products: $e');
    }
  }

  double textToDouble(String text) {
    double? parsedValue =
        double.tryParse(text.replaceAll('.', '').replaceAll(',', '.'));
    if (parsedValue != null) {
      return parsedValue;
    }
    return 0;
  }

  void _updateProductSettings() {
    if (_selectedProduct != null) {
      _minCredit = _selectedProduct!.creditoMinimo;
      _maxCredit = _selectedProduct!.creditoMaximo;
      _minPayment = _selectedProduct!.prazoMinimo.toDouble();
      _maxPayment = _selectedProduct!.prazoMaximo.toDouble();
      _minGrace = _selectedProduct!.carenciaMinima.toDouble();
      _maxGrace = _selectedProduct!.carenciaMaxima.toDouble();

      _creditController.text = _minCredit.toString();
      _paymentController.text = _minPayment.toString();
      _gracePeriodController.text = _minGrace.toString();
    }
    setState(() {});
  }

  void _simulateInstallments() {
    if (_formKey.currentState!.validate()) {
      simulate = Simulate(
        valorFinanciamento: textToDouble(_creditController.text),
        prazoPagamento: int.parse(_paymentController.text),
        carenciaMeses: int.parse(_gracePeriodController.text),
        product: _selectedProduct!,
      );
      context.go('/simulacao', extra: simulate);
    }
  }
}
