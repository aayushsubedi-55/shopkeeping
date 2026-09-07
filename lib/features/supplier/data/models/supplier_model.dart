import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';

/// DTO for [Supplier]: adds map (de)serialization on top of the pure entity.
class SupplierModel extends Supplier {
  const SupplierModel({
    required super.id,
    required super.name,
    super.wechatId,
    super.createdAt,
    super.updatedAt,
  });

  SupplierModel copyWith({
    String? id,
    String? name,
    String? wechatId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      wechatId: wechatId ?? this.wechatId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Request body for create/update. `id`/timestamps are server-assigned and
  /// deliberately left out. The backend's Pydantic schemas take snake_case
  /// with no alias, so keys here must match exactly.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'wechat_id': wechatId,
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      wechatId: map['wechat_id']?.toString(),
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
