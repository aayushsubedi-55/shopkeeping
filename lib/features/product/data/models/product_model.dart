import 'package:shopnepal/features/product/domain/entities/product.dart';

/// DTO for [Product]: adds map (de)serialization on top of the pure entity.
/// The backend's Pydantic schemas take snake_case with no alias, so keys
/// here must match exactly (see the `shopnepal-conventions` skill).
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.articleNo,
    super.nameCn,
    super.nameEn,
    required super.supplierId,
    super.imageUrl,
    super.defaultRatio,
    super.createdAt,
    super.updatedAt,
  });

  /// Request body for create/update. `id`/timestamps are server-assigned and
  /// deliberately left out.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'article_no': articleNo,
      'name_cn': nameCn,
      'name_en': nameEn,
      'supplier_id': supplierId,
      'image_url': imageUrl,
      'default_ratio': defaultRatio,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    final rawRatio = map['default_ratio'];
    return ProductModel(
      id: map['id']?.toString() ?? '',
      articleNo: map['article_no']?.toString() ?? '',
      nameCn: map['name_cn']?.toString(),
      nameEn: map['name_en']?.toString(),
      supplierId: map['supplier_id']?.toString() ?? '',
      imageUrl: map['image_url']?.toString(),
      defaultRatio: rawRatio is Map
          ? rawRatio.map(
              (key, value) => MapEntry(key.toString(), (value as num).toInt()),
            )
          : null,
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
