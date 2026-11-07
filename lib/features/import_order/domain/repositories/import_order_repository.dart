import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';

abstract class ImportOrderRepository {
  // ── Orders ────────────────────────────────────────────────────────────────

  Future<DataResponse<List<ImportOrder>>> getAll();

  Future<DataResponse<ImportOrder>> getById(String id);

  Future<DataResponse<ImportOrder>> create(ImportOrderCreateInput input);

  Future<DataResponse<ImportOrder>> update(String id, ImportOrderCreateInput input);

  Future<DataResponse<void>> delete(String id);

  // ── Order Lines ───────────────────────────────────────────────────────────

  Future<DataResponse<List<ImportOrderLine>>> getLines(String orderId);

  Future<DataResponse<ImportOrderLine>> createLine(
    String orderId,
    ImportOrderLineCreateInput input,
  );

  Future<DataResponse<ImportOrderLine>> updateLine(
    String orderId,
    String lineId,
    ImportOrderLineCreateInput input,
  );

  Future<DataResponse<void>> deleteLine(String orderId, String lineId);

  // ── Receive Order ─────────────────────────────────────────────────────────

  Future<DataResponse<void>> receiveOrder(String orderId);

  // ── Reports ───────────────────────────────────────────────────────────────

  Future<DataResponse<List<LandedCostLine>>> getLandedCost({String? orderId});

  // ── Stock ─────────────────────────────────────────────────────────────────

  Future<DataResponse<List<StockOnHand>>> getStock({String? productId});

  Future<DataResponse<StockMovement>> createStockMovement(StockMovementInput input);
}