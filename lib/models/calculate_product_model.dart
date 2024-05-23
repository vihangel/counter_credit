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

  double get valorTotal => parcelas.fold(
      0, (previousValue, element) => previousValue + element.valor);

  double get amortizacaoTotal => parcelas.fold(
      0, (previousValue, element) => previousValue + element.amortizacao);

  double get jurosTotal => parcelas.fold(
      0, (previousValue, element) => previousValue + element.juros);

  double get correcaoMonetariaTotal => parcelas.fold(
      0, (previousValue, element) => previousValue + element.correcaoMonetaria);

  double get bonusTotal => parcelas.fold(
      0, (previousValue, element) => previousValue + element.comBonus);

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
  double comBonus;

  Parcela({
    required this.parcela,
    required this.valor,
    required this.amortizacao,
    required this.correcaoMonetaria,
    required this.juros,
    required this.saldoDevedor,
    this.comBonus = 0,
  });

  factory Parcela.fromJson(Map<String, dynamic> json) =>
      _$ParcelaFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelaToJson(this);
}
