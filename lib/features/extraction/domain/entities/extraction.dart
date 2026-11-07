import 'package:equatable/equatable.dart';

/// Represents an extracted product from a supplier photo.
class ExtractedProduct extends Equatable {
  final String articleNo;
  final String? nameCn;
  final String? nameEn;
  final String sizeRange;
  final int cases;
  final Map<String, int> ratio;
  final String unitPrice;
  final String priceBasis; // per_case | per_pair
  final String currency;
  final double confidence; // 0.0 - 1.0

  const ExtractedProduct({
    required this.articleNo,
    this.nameCn,
    this.nameEn,
    required this.sizeRange,
    required this.cases,
    required this.ratio,
    required this.unitPrice,
    required this.priceBasis,
    required this.currency,
    required this.confidence,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        articleNo,
        nameCn,
        nameEn,
        sizeRange,
        cases,
        ratio,
        unitPrice,
        priceBasis,
        currency,
        confidence,
      ];
}

/// Complete extraction result from a supplier photo.
class ExtractedSheet extends Equatable {
  final String? supplierName;
  final String? supplierWechat;
  final List<ExtractedProduct> products;
  final String? notes;

  const ExtractedSheet({
    this.supplierName,
    this.supplierWechat,
    required this.products,
    this.notes,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [supplierName, supplierWechat, products, notes];
}