import 'package:shopnepal/core/logger/logger.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/import_order/data/datasources/import_order_remote_datasource.dart';
import 'package:shopnepal/features/import_order/data/models/import_order_model.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/domain/repositories/import_order_repository.dart';

class ImportOrderRepositoryImpl implements ImportOrderRepository {
  final ApiProvider apiProvider;
  late ImportOrderRemoteDataSource remoteDataSource;

  ImportOrderRepositoryImpl({required this.apiProvider}) {
    remoteDataSource = ImportOrderRemoteDataSource(apiProvider: apiProvider);
  }

  // ── Orders ────────────────────────────────────────────────────────────────

  @override
  Future<DataResponse<List<ImportOrder>>> getAll() async {
    try {
      final res = await remoteDataSource.getAll();
      final rawList = res['data']?['data'] ?? res['data'];
      if (rawList is! List) {
        return DataResponse.error('Invalid orders list payload');
      }
      final orders = rawList
          .map((e) => ImportOrderModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      return DataResponse.success(orders);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<ImportOrder>> getById(String id) async {
    try {
      final res = await remoteDataSource.getById(id);
      final rawOrder = res['data']?['data'] ?? res['data'];
      if (rawOrder is! Map) {
        return DataResponse.error('Invalid order payload');
      }
      final order = ImportOrderModel.fromMap(Map<String, dynamic>.from(rawOrder));
      return DataResponse.success(order);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<ImportOrder>> create(ImportOrderCreateInput input) async {
    try {
      final res = await remoteDataSource.create(input.toMap());
      final rawOrder = res['data']?['data'] ?? res['data'];
      if (rawOrder is! Map) {
        return DataResponse.error('Invalid created order payload');
      }
      final order = ImportOrderModel.fromMap(Map<String, dynamic>.from(rawOrder));
      return DataResponse.success(order);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<ImportOrder>> update(
    String id,
    ImportOrderCreateInput input,
  ) async {
    try {
      final res = await remoteDataSource.update(id, input.toMap());
      final rawOrder = res['data']?['data'] ?? res['data'];
      if (rawOrder is! Map) {
        return DataResponse.error('Invalid updated order payload');
      }
      final order = ImportOrderModel.fromMap(Map<String, dynamic>.from(rawOrder));
      return DataResponse.success(order);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<void>> delete(String id) async {
    try {
      await remoteDataSource.delete(id);
      return DataResponse.success(null);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  // ── Order Lines ───────────────────────────────────────────────────────────

  @override
  Future<DataResponse<List<ImportOrderLine>>> getLines(String orderId) async {
    try {
      final res = await remoteDataSource.getLines(orderId);
      final rawList = res['data']?['data'] ?? res['data'];
      if (rawList is! List) {
        return DataResponse.error('Invalid order lines list payload');
      }
      final lines = rawList
          .map((e) => ImportOrderLineModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      return DataResponse.success(lines);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<ImportOrderLine>> createLine(
    String orderId,
    ImportOrderLineCreateInput input,
  ) async {
    try {
      final res = await remoteDataSource.createLine(orderId, input.toMap());
      final rawLine = res['data']?['data'] ?? res['data'];
      if (rawLine is! Map) {
        return DataResponse.error('Invalid created order line payload');
      }
      final line = ImportOrderLineModel.fromMap(Map<String, dynamic>.from(rawLine));
      return DataResponse.success(line);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<ImportOrderLine>> updateLine(
    String orderId,
    String lineId,
    ImportOrderLineCreateInput input,
  ) async {
    try {
      final res = await remoteDataSource.updateLine(orderId, lineId, input.toMap());
      final rawLine = res['data']?['data'] ?? res['data'];
      if (rawLine is! Map) {
        return DataResponse.error('Invalid updated order line payload');
      }
      final line = ImportOrderLineModel.fromMap(Map<String, dynamic>.from(rawLine));
      return DataResponse.success(line);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<void>> deleteLine(String orderId, String lineId) async {
    try {
      await remoteDataSource.deleteLine(orderId, lineId);
      return DataResponse.success(null);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  // ── Receive Order ─────────────────────────────────────────────────────────

  @override
  Future<DataResponse<void>> receiveOrder(String orderId) async {
    try {
      await remoteDataSource.receiveOrder(orderId);
      return DataResponse.success(null);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  // ── Reports ───────────────────────────────────────────────────────────────

  @override
  Future<DataResponse<List<LandedCostLine>>> getLandedCost({String? orderId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (orderId != null) queryParams['order_id'] = orderId;

      final res = await apiProvider.get('reports/landed-cost', queryParameters: queryParams);
      final rawList = res['data']?['data'] ?? res['data'];
      if (rawList is! List) {
        return DataResponse.error('Invalid landed cost list payload');
      }
      final lines = rawList
          .map((e) => LandedCostLineModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      return DataResponse.success(lines);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  // ── Stock ─────────────────────────────────────────────────────────────────

  @override
  Future<DataResponse<List<StockOnHand>>> getStock({String? productId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (productId != null) queryParams['product_id'] = productId;

      final res = await apiProvider.get('stock', queryParameters: queryParams);
      final rawList = res['data']?['data'] ?? res['data'];
      if (rawList is! List) {
        return DataResponse.error('Invalid stock list payload');
      }
      final stock = rawList
          .map((e) => StockOnHandModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();
      return DataResponse.success(stock);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<StockMovement>> createStockMovement(StockMovementInput input) async {
    try {
      final res = await apiProvider.post('stock/movements', input.toMap());
      final rawMovement = res['data']?['data'] ?? res['data'];
      if (rawMovement is! Map) {
        return DataResponse.error('Invalid stock movement payload');
      }
      final movement = StockMovementModel.fromMap(Map<String, dynamic>.from(rawMovement));
      return DataResponse.success(movement);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }
}