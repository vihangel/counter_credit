import 'dart:math';

import 'package:counter_credit/models/calculate_product_model.dart';
import 'package:counter_credit/models/simulator_configuration_model.dart';

class Simulate {
  double valorFinanciamento;
  Product product;
  int prazoPagamento;
  int carenciaMeses;

  Simulate({
    required this.valorFinanciamento,
    required this.product,
    required this.prazoPagamento,
    required this.carenciaMeses,
  });

  CalculateProductModel gerarParcelas() {
    List<Parcela> parcelas = [];

    double saldoDevedor = valorFinanciamento;
    num taxaJurosMensal = pow(1 + product.taxaDeJuros / 100, (1 / 12));
    int prazoPagamentoEfetivo = prazoPagamento - carenciaMeses;

    double valorParcela = valorFinanciamento *
        pow(taxaJurosMensal, prazoPagamentoEfetivo) *
        (taxaJurosMensal - 1) /
        (pow(taxaJurosMensal, prazoPagamentoEfetivo) - 1);

    for (int i = 1; i <= carenciaMeses; i++) {
      double juros = saldoDevedor * (taxaJurosMensal - 1);
      parcelas.add(Parcela(
        parcela: i,
        valor: juros,
        amortizacao: 0,
        correcaoMonetaria: 0,
        juros: juros,
        saldoDevedor: saldoDevedor,
      ));
    }

    for (int i = carenciaMeses + 1; i <= prazoPagamento; i++) {
      double juros = saldoDevedor * (taxaJurosMensal - 1);
      double correcaoMonetaria = saldoDevedor * 0.0;

      double valorAmortizacao = valorParcela - juros - correcaoMonetaria;

      saldoDevedor -= valorAmortizacao;

      parcelas.add(Parcela(
        parcela: i,
        valor: valorParcela,
        amortizacao: valorAmortizacao,
        correcaoMonetaria: correcaoMonetaria,
        juros: juros,
        saldoDevedor: saldoDevedor,
      ));
    }

    return CalculateProductModel(
      product: product,
      parcelas: parcelas,
      taxaDeJurosParaApresentacao:
          "${(product.taxaDeJuros).toStringAsFixed(2)}% a.m.",
      indexador: 0,
      prazoPagamento: prazoPagamento,
      carenciaMeses: carenciaMeses,
      valorFinanciamento: valorFinanciamento,
    );
  }
}
