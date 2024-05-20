import 'package:counter_credit/models/simulator_configuration_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calculate_product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CalculateProductModel {
  Product? product;

  List<Parcela> parcelas;
  String taxaDeJurosParaApresentacao;
  int indexador;
  int prazoPagamento;
  int carenciaMeses;
  double valorFinanciamento;

  CalculateProductModel({
    this.product,
    required this.parcelas,
    required this.taxaDeJurosParaApresentacao,
    required this.indexador,
    required this.prazoPagamento,
    required this.carenciaMeses,
    required this.valorFinanciamento,
  });

  factory CalculateProductModel.fromJson(Map<String, dynamic> json) =>
      _$CalculateProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalculateProductModelToJson(this);
}

@JsonSerializable()
class Parcela {
  int parcela;
  double valor;
  double amortizacao;
  double correcaoMonetaria;
  double juros;
  double saldoDevedor;

  Parcela({
    required this.parcela,
    required this.valor,
    required this.amortizacao,
    required this.correcaoMonetaria,
    required this.juros,
    required this.saldoDevedor,
  });

  factory Parcela.fromJson(Map<String, dynamic> json) =>
      _$ParcelaFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelaToJson(this);
}
