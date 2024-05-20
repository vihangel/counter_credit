// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calculate_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalculateProductModel _$CalculateProductModelFromJson(
        Map<String, dynamic> json) =>
    CalculateProductModel(
      product: json['product'] == null
          ? null
          : Product.fromJson(json['product'] as Map<String, dynamic>),
      parcelas: (json['parcelas'] as List<dynamic>)
          .map((e) => Parcela.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxaDeJurosParaApresentacao:
          json['taxaDeJurosParaApresentacao'] as String,
      indexador: (json['indexador'] as num).toInt(),
      prazoPagamento: (json['prazoPagamento'] as num).toInt(),
      carenciaMeses: (json['carenciaMeses'] as num).toInt(),
      valorFinanciamento: (json['valorFinanciamento'] as num).toDouble(),
    );

Map<String, dynamic> _$CalculateProductModelToJson(
        CalculateProductModel instance) =>
    <String, dynamic>{
      'product': instance.product?.toJson(),
      'parcelas': instance.parcelas.map((e) => e.toJson()).toList(),
      'taxaDeJurosParaApresentacao': instance.taxaDeJurosParaApresentacao,
      'indexador': instance.indexador,
      'prazoPagamento': instance.prazoPagamento,
      'carenciaMeses': instance.carenciaMeses,
      'valorFinanciamento': instance.valorFinanciamento,
    };

Parcela _$ParcelaFromJson(Map<String, dynamic> json) => Parcela(
      parcela: (json['parcela'] as num).toInt(),
      valor: (json['valor'] as num).toDouble(),
      amortizacao: (json['amortizacao'] as num).toDouble(),
      correcaoMonetaria: (json['correcaoMonetaria'] as num).toDouble(),
      juros: (json['juros'] as num).toDouble(),
      saldoDevedor: (json['saldoDevedor'] as num).toDouble(),
      comBonus: (json['comBonus'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ParcelaToJson(Parcela instance) => <String, dynamic>{
      'parcela': instance.parcela,
      'valor': instance.valor,
      'amortizacao': instance.amortizacao,
      'correcaoMonetaria': instance.correcaoMonetaria,
      'juros': instance.juros,
      'saldoDevedor': instance.saldoDevedor,
      'comBonus': instance.comBonus,
    };
