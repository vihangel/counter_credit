import 'package:json_annotation/json_annotation.dart';

part 'simulator_configuration_model.g.dart';

@JsonSerializable()
class Product {
  String id;

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

  copyWith({
    String? id,
    double? taxaDeJuros,
    double? creditoMinimo,
    double? creditoMaximo,
    int? prazoMinimo,
    int? prazoMaximo,
    int? carenciaMinima,
    int? carenciaMaxima,
    double? bonusDia,
    String? nome,
    String? descricao,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      taxaDeJuros: taxaDeJuros ?? this.taxaDeJuros,
      creditoMinimo: creditoMinimo ?? this.creditoMinimo,
      creditoMaximo: creditoMaximo ?? this.creditoMaximo,
      prazoMinimo: prazoMinimo ?? this.prazoMinimo,
      prazoMaximo: prazoMaximo ?? this.prazoMaximo,
      carenciaMinima: carenciaMinima ?? this.carenciaMinima,
      carenciaMaxima: carenciaMaxima ?? this.carenciaMaxima,
      bonusDia: bonusDia ?? this.bonusDia,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
