import 'package:counter_credit/models/calculate_product_model.dart';
import 'package:counter_credit/models/simulate.dart';
import 'package:flutter/material.dart';

class SimulateView extends StatelessWidget {
  final Simulate simulate;
  final String payment;
  final String credit;
  final String gracePeriod;

  const SimulateView({
    super.key,
    required this.simulate,
    required this.payment,
    required this.credit,
    required this.gracePeriod,
  });

  String formatCurrency(double value) {
    return 'R\$${value.toStringAsFixed(2).replaceAll('.', ',').replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+,)'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    CalculateProductModel product = simulate.gerarParcelas();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Expanded(
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: product.parcelas.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Parcela ${product.parcelas[index].parcela}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Valor: ${formatCurrency(product.parcelas[index].valor)}'),
                  Text(
                      'Amortização: ${formatCurrency(product.parcelas[index].amortizacao)}'),
                  Text(
                      'Correção Monetária: ${formatCurrency(product.parcelas[index].correcaoMonetaria)}'),
                  Text(
                      'Juros: ${formatCurrency(product.parcelas[index].juros)}'),
                  Text(
                      'Saldo Devedor: ${formatCurrency(product.parcelas[index].saldoDevedor)}'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
