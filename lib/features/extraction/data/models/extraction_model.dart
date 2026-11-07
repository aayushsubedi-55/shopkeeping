import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';

/// DTO for [ExtractedProduct].
class ExtractedProductModel extends ExtractedProduct {
  const ExtractedProductModel({
    required super.articleNo,
    super.nameCn,
    super.nameEn,
    required super.sizeRange,
    required super.cases,
    required super.ratio,
    required super.unitPrice,
    required super.priceBasis,
    required super.currency,
    required super.confidence,
  });

  factory ExtractedProductModel.fromMap(Map<String, dynamic> map) {
    final rawRatio = map['ratio'];
    return ExtractedProductModel(
      articleNo: map['article_no']?.toString() ?? '',
      nameCn: map['name_cn']?.toString(),
      nameEn: map['name_en']?.toString(),
      sizeRange: map['size_range']?.toString() ?? '',
      cases: (map['cases'] as num?)?.toInt() ?? 0,
      ratio: rawRatio is Map
          ? rawRatio.map(
              (key, value) => MapEntry(key.toString(), (value as num).toInt()),
            )
          : const {},
      unitPrice: map['unit_price']?.toString() ?? '0',
      priceBasis: map['price_basis']?.toString() ?? 'per_case',
      currency: map['currency']?.toString() ?? 'CNY',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'article_no': articleNo,
      'name_cn': nameCn,
      'name_en': nameEn,
      'size_range': sizeRange,
      'cases': cases,
      'ratio': ratio,
      'unit_price': unitPrice,
      'price_basis': priceBasis,
      'currency': currency,
      'confidence': confidence,
    };
  }
}

/// DTO for [ExtractedSheet].
class ExtractedSheetModel extends ExtractedSheet {
  const ExtractedSheetModel({
    super.supplierName,
    super.supplierWechat,
    required super.products,
    super.notes,
  });

  factory ExtractedSheetModel.fromMap(Map<String, dynamic> map) {
    final rawProducts = map['products'];
    return ExtractedSheetModel(
      supplierName: map['supplier_name']?.toString(),
      supplierWechat: map['supplier_wechat']?.toString(),
      products: rawProducts is List
          ? rawProducts
              .map((e) => ExtractedProductModel.fromMap(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      notes: map['notes']?.toString(),
    );
  }
}