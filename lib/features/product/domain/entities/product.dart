import 'package:equatable/equatable.dart';

/// A catalog product. Pure domain value object — no JSON, no Flutter.
///
/// `defaultRatio` only pre-fills the order-review screen; the ratio that
/// actually counts is snapshotted per order line, never read live off here.
class Product extends Equatable {
  final String id;
  final String articleNo;
  final String? nameCn;
  final String? nameEn;
  final String supplierId;
  final String? imageUrl;
  final Map<String, int>? defaultRatio;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.articleNo,
    this.nameCn,
    this.nameEn,
    required this.supplierId,
    this.imageUrl,
    this.defaultRatio,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    id,
    articleNo,
    nameCn,
    nameEn,
    supplierId,
    imageUrl,
    defaultRatio,
    createdAt,
    updatedAt,
  ];
}
