import 'package:counter_credit/screens/admin/notify_product_listener.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _supabaseClient = Supabase.instance.client;

  String _nome = '';
  String _descricao = '';
  double _taxaDeJuros = 0.0;
  double _creditoMinimo = 0.0;
  double _creditoMaximo = 0.0;
  int _prazoMinimo = 0;
  int _prazoMaximo = 0;
  int _carenciaMinima = 0;
  int _carenciaMaxima = 0;
  int? _bonusDia;

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await _supabaseClient.from('produtos').insert({
        'nome': _nome,
        'descricao': _descricao,
        'taxaDeJuros': _taxaDeJuros,
        'creditoMinimo': _creditoMinimo,
        'creditoMaximo': _creditoMaximo,
        'prazoMinimo': _prazoMinimo,
        'prazoMaximo': _prazoMaximo,
        'carenciaMinima': _carenciaMinima,
        'carenciaMaxima': _carenciaMaxima,
        'bonusDia': _bonusDia,
      });

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto adicionado com sucesso!')),
        );
        Provider.of<ProductListener>(context, listen: false)
            .notifyProductChanges();
        GoRouter.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar produto: ${response.message}')),
        );
      }
    }
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
                    decoration:
                        const InputDecoration(labelText: 'Taxa de Juros (%)'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) =>
                        _taxaDeJuros = double.parse(value ?? '0'),
                    validator: (value) {
                      if (value == null || double.tryParse(value) == null) {
                        return 'Por favor, insira uma taxa de juros válida';
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
                    onSaved: (value) =>
                        _creditoMinimo = double.parse(value ?? '0'),
                    validator: (value) {
                      if (value != null && double.tryParse(value) == null) {
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
                    onSaved: (value) =>
                        _creditoMaximo = double.parse(value ?? '0'),
                    validator: (value) {
                      if (value != null && double.tryParse(value) == null) {
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
                    decoration: const InputDecoration(labelText: 'Bônus Dia'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _bonusDia = int.tryParse(value ?? ''),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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