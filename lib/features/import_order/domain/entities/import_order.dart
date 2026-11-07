import 'package:equatable/equatable.dart';

/// An import order. Pure domain value object — no JSON, no Flutter.
class ImportOrder extends Equatable {
  final String id;
  final String status; // draft | ordered | received | cancelled
  final DateTime? orderDate;
  final String? fxRateToNpr;
  final String freightNpr;
  final String customsNpr;
  final String otherNpr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ImportOrder({
    required this.id,
    required this.status,
    this.orderDate,
    this.fxRateToNpr,
    required this.freightNpr,
    required this.customsNpr,
    required this.otherNpr,
    this.createdAt,
    this.updatedAt,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        status,
        orderDate,
        fxRateToNpr,
        freightNpr,
        customsNpr,
        otherNpr,
        createdAt,
        updatedAt,
      ];
}

/// An import order line. The ratio is SNAPSHOTTED per line — this is what
/// actually counts for stock/cost calculations. Never read ratio live from
/// the product's defaultRatio.
class ImportOrderLine extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final int cases;
  final Map<String, int> ratio; // e.g., {'31': 2, '32': 2}
  final String unitPrice;
  final String priceBasis; // per_case | per_pair
  final String currency;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ImportOrderLine({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.cases,
    required this.ratio,
    required this.unitPrice,
    required this.priceBasis,
    required this.currency,
    this.createdAt,
    this.updatedAt,
  });

  /// Total pairs per case = sum of ratio values
  int get pairsPerCase => ratio.values.fold(0, (sum, v) => sum + v);

  /// Total pairs for this line = cases * pairsPerCase
  int get totalPairs => cases * pairsPerCase;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        cases,
        ratio,
        unitPrice,
        priceBasis,
        currency,
        createdAt,
        updatedAt,
      ];
}

/// Input for creating a new import order.
class ImportOrderCreateInput extends Equatable {
  final String status; // draft | ordered | received | cancelled
  final DateTime? orderDate;
  final String? fxRateToNpr;
  final String freightNpr;
  final String customsNpr;
  final String otherNpr;

  const ImportOrderCreateInput({
    this.status = 'draft',
    this.orderDate,
    this.fxRateToNpr,
    this.freightNpr = '0',
    this.customsNpr = '0',
    this.otherNpr = '0',
  });

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

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        status,
        orderDate,
        fxRateToNpr,
        freightNpr,
        customsNpr,
        otherNpr,
      ];
}

/// Input for creating a new import order line.
class ImportOrderLineCreateInput extends Equatable {
  final String productId;
  final int cases;
  final Map<String, int> ratio;
  final String unitPrice;
  final String priceBasis; // per_case | per_pair
  final String currency;

  const ImportOrderLineCreateInput({
    required this.productId,
    required this.cases,
    required this.ratio,
    required this.unitPrice,
    required this.priceBasis,
    required this.currency,
  });

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

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        productId,
        cases,
        ratio,
        unitPrice,
        priceBasis,
        currency,
      ];
}

/// Landed cost report line from /reports/landed-cost.
class LandedCostLine extends Equatable {
  final String id;
  final String orderId;
  final String productId;
  final int cases;
  final int pairsPerCase;
  final int pairs;
  final String goodsCny;
  final String goodsNpr;
  final String overheadNpr;
  final String landedCostPerPairNpr;

  const LandedCostLine({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.cases,
    required this.pairsPerCase,
    required this.pairs,
    required this.goodsCny,
    required this.goodsNpr,
    required this.overheadNpr,
    required this.landedCostPerPairNpr,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        orderId,
        productId,
        cases,
        pairsPerCase,
        pairs,
        goodsCny,
        goodsNpr,
        overheadNpr,
        landedCostPerPairNpr,
      ];
}

/// Stock on hand from /stock (reads v_stock_on_hand view).
class StockOnHand extends Equatable {
  final String productId;
  final int size;
  final int pairs;

  const StockOnHand({
    required this.productId,
    required this.size,
    required this.pairs,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [productId, size, pairs];
}

/// Stock movement input for /stock/movements.
class StockMovementInput extends Equatable {
  final String productId;
  final int size;
  final int qty; // negative for sale/damage, positive for adjustment
  final String reason; // sale | adjustment | damage

  const StockMovementInput({
    required this.productId,
    required this.size,
    required this.qty,
    required this.reason,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product_id': productId,
      'size': size,
      'qty': qty,
      'reason': reason,
    };
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [productId, size, qty, reason];
}

/// Stock movement output.
class StockMovement extends Equatable {
  final String id;
  final String productId;
  final int size;
  final int qty;
  final String reason;
  final String? refType;
  final String? refId;
  final DateTime? createdAt;

  const StockMovement({
    required this.id,
    required this.productId,
    required this.size,
    required this.qty,
    required this.reason,
    this.refType,
    this.refId,
    this.createdAt,
  });

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
        id,
        productId,
        size,
        qty,
        reason,
        refType,
        refId,
        createdAt,
      ];
}