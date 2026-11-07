import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';

/// DTO for [ImportOrder]: adds map (de)serialization on top of the pure entity.
/// The backend's Pydantic schemas take snake_case with no alias, so keys here
/// must match exactly (see the `shopnepal-conventions` skill).
class ImportOrderModel extends ImportOrder {
  const ImportOrderModel({
    required super.id,
    required super.status,
    super.orderDate,
    super.fxRateToNpr,
    required super.freightNpr,
    required super.customsNpr,
    required super.otherNpr,
    super.createdAt,
    super.updatedAt,
  });

  ImportOrderModel copyWith({
    String? id,
    String? status,
    DateTime? orderDate,
    String? fxRateToNpr,
    String? freightNpr,
    String? customsNpr,
    String? otherNpr,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ImportOrderModel(
      id: id ?? this.id,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      fxRateToNpr: fxRateToNpr ?? this.fxRateToNpr,
      freightNpr: freightNpr ?? this.freightNpr,
      customsNpr: customsNpr ?? this.customsNpr,
      otherNpr: otherNpr ?? this.otherNpr,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Request body for create/update. `id`/timestamps are server-assigned and
  /// deliberately left out.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'order_date': orderDate?.toIso8601String().split('T').first,
      'fx_rate_to_npr': fxRateToNpr,
      'freight_npr': freightNpr,
      'customs_npr': customsNpr,
      'other_npr': otherNpr,
    };
  }

  factory ImportOrderModel.fromMap(Map<String, dynamic> map) {
    return ImportOrderModel(
      id: map['id']?.toString() ?? '',
      status: map['status']?.toString() ?? 'draft',
      orderDate: _parseDate(map['order_date']),
      fxRateToNpr: map['fx_rate_to_npr']?.toString(),
      freightNpr: map['freight_npr']?.toString() ?? '0',
      customsNpr: map['customs_npr']?.toString() ?? '0',
      otherNpr: map['other_npr']?.toString() ?? '0',
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// DTO for [ImportOrderLine].
class ImportOrderLineModel extends ImportOrderLine {
  const ImportOrderLineModel({
    required super.id,
    required super.orderId,
    required super.productId,
    required super.cases,
    required super.ratio,
    required super.unitPrice,
    required super.priceBasis,
    required super.currency,
    super.createdAt,
    super.updatedAt,
  });

  ImportOrderLineModel copyWith({
    String? id,
    String? orderId,
    String? productId,
    int? cases,
    Map<String, int>? ratio,
    String? unitPrice,
    String? priceBasis,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ImportOrderLineModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      cases: cases ?? this.cases,
      ratio: ratio ?? this.ratio,
      unitPrice: unitPrice ?? this.unitPrice,
      priceBasis: priceBasis ?? this.priceBasis,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Request body for create/update.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'cases': cases,
      'ratio': ratio,
      'unit_price': unitPrice,
      'price_basis': priceBasis,
      'currency': currency,
    };
  }

  factory ImportOrderLineModel.fromMap(Map<String, dynamic> map) {
    final rawRatio = map['ratio'];
    return ImportOrderLineModel(
      id: map['id']?.toString() ?? '',
      orderId: map['order_id']?.toString() ?? '',
      productId: map['product_id']?.toString() ?? '',
      cases: (map['cases'] as num?)?.toInt() ?? 0,
      ratio: rawRatio is Map
          ? rawRatio.map(
              (key, value) => MapEntry(key.toString(), (value as num).toInt()),
            )
          : const {},
      unitPrice: map['unit_price']?.toString() ?? '0',
      priceBasis: map['price_basis']?.toString() ?? 'per_case',
      currency: map['currency']?.toString() ?? 'CNY',
      createdAt: _parseDate(map['created_at']),
      updatedAt: _parseDate(map['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}

/// DTO for [LandedCostLine].
class LandedCostLineModel extends LandedCostLine {
  const LandedCostLineModel({
    required super.id,
    required super.orderId,
    required super.productId,
    required super.cases,
    required super.pairsPerCase,
    required super.pairs,
    required super.goodsCny,
    required super.goodsNpr,
    required super.overheadNpr,
    required super.landedCostPerPairNpr,
  });

  factory LandedCostLineModel.fromMap(Map<String, dynamic> map) {
    return LandedCostLineModel(
      id: map['id']?.toString() ?? '',
      orderId: map['order_id']?.toString() ?? '',
      productId: map['product_id']?.toString() ?? '',
      cases: (map['cases'] as num?)?.toInt() ?? 0,
      pairsPerCase: (map['pairs_per_case'] as num?)?.toInt() ?? 0,
      pairs: (map['pairs'] as num?)?.toInt() ?? 0,
      goodsCny: map['goods_cny']?.toString() ?? '0',
      goodsNpr: map['goods_npr']?.toString() ?? '0',
      overheadNpr: map['overhead_npr']?.toString() ?? '0',
      landedCostPerPairNpr: map['landed_cost_per_pair_npr']?.toString() ?? '0',
    );
  }
}

/// DTO for [StockOnHand].
class StockOnHandModel extends StockOnHand {
  const StockOnHandModel({
    required super.productId,
    required super.size,
    required super.pairs,
  });

  factory StockOnHandModel.fromMap(Map<String, dynamic> map) {
    return StockOnHandModel(
      productId: map['product_id']?.toString() ?? '',
      size: (map['size'] as num?)?.toInt() ?? 0,
      pairs: (map['pairs'] as num?)?.toInt() ?? 0,
    );
  }
}

/// DTO for [StockMovement].
class StockMovementModel extends StockMovement {
  const StockMovementModel({
    required super.id,
    required super.productId,
    required super.size,
    required super.qty,
    required super.reason,
    super.refType,
    super.refId,
    super.createdAt,
  });

  factory StockMovementModel.fromMap(Map<String, dynamic> map) {
    return StockMovementModel(
      id: map['id']?.toString() ?? '',
      productId: map['product_id']?.toString() ?? '',
      size: (map['size'] as num?)?.toInt() ?? 0,
      qty: (map['qty'] as num?)?.toInt() ?? 0,
      reason: map['reason']?.toString() ?? '',
      refType: map['ref_type']?.toString(),
      refId: map['ref_id']?.toString(),
      createdAt: _parseDate(map['created_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}