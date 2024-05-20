import 'package:json_annotation/json_annotation.dart';

part 'simulator_configuration_model.g.dart';

@JsonSerializable()
class Product {
  int id;

  double taxaDeJuros;

  double creditoMinimo;
  double creditoMaximo;
  int prazoMinimo;
  int prazoMaximo;
  int carenciaMinima;
  int carenciaMaxima;
  double? bonusDia;
  String nome;
  String descricao;
  DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.taxaDeJuros,
    required this.creditoMinimo,
    required this.creditoMaximo,
    required this.prazoMinimo,
    required this.prazoMaximo,
    required this.carenciaMinima,
    required this.carenciaMaxima,
    this.bonusDia,
    required this.nome,
    required this.descricao,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
