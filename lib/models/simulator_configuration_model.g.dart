// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulator_configuration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num).toInt(),
      taxaDeJuros: (json['taxaDeJuros'] as num).toDouble(),
      creditoMinimo: (json['creditoMinimo'] as num).toDouble(),
      creditoMaximo: (json['creditoMaximo'] as num).toDouble(),
      prazoMinimo: (json['prazoMinimo'] as num).toInt(),
      prazoMaximo: (json['prazoMaximo'] as num).toInt(),
      carenciaMinima: (json['carenciaMinima'] as num).toInt(),
      carenciaMaxima: (json['carenciaMaxima'] as num).toInt(),
      bonusDia: (json['bonusDia'] as num?)?.toDouble(),
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'taxaDeJuros': instance.taxaDeJuros,
      'creditoMinimo': instance.creditoMinimo,
      'creditoMaximo': instance.creditoMaximo,
      'prazoMinimo': instance.prazoMinimo,
      'prazoMaximo': instance.prazoMaximo,
      'carenciaMinima': instance.carenciaMinima,
      'carenciaMaxima': instance.carenciaMaxima,
      'bonusDia': instance.bonusDia,
      'nome': instance.nome,
      'descricao': instance.descricao,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
