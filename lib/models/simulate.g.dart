// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simulate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Simulate _$SimulateFromJson(Map<String, dynamic> json) => Simulate(
      valorFinanciamento: (json['valorFinanciamento'] as num).toDouble(),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      prazoPagamento: (json['prazoPagamento'] as num).toInt(),
      carenciaMeses: (json['carenciaMeses'] as num).toInt(),
    );

Map<String, dynamic> _$SimulateToJson(Simulate instance) => <String, dynamic>{
      'valorFinanciamento': instance.valorFinanciamento,
      'product': instance.product.toJson(),
      'prazoPagamento': instance.prazoPagamento,
      'carenciaMeses': instance.carenciaMeses,
    };
