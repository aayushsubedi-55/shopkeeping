import 'package:shopnepal/core/network/http.dart';

/// Thin URI builder over the shared [ApiProvider]. No parsing, no error
/// handling — that is the repository's job.
class ImportOrderRemoteDataSource {
  final ApiProvider apiProvider;
  final String basePath = 'import-orders';

  ImportOrderRemoteDataSource({required this.apiProvider});

  // ── Orders ────────────────────────────────────────────────────────────────

  Future<dynamic> getAll() => apiProvider.get(basePath);

  Future<dynamic> getById(String id) => apiProvider.get('$basePath/$id');

  Future<dynamic> create(Map<String, dynamic> body) =>
      apiProvider.post(basePath, body);

  Future<dynamic> update(String id, Map<String, dynamic> body) =>
      apiProvider.put('$basePath/$id', body: body);

  Future<dynamic> delete(String id) => apiProvider.delete('$basePath/$id');

  // ── Order Lines ───────────────────────────────────────────────────────────

  Future<dynamic> getLines(String orderId) =>
      apiProvider.get('$basePath/$orderId/lines');

  Future<dynamic> createLine(String orderId, Map<String, dynamic> body) =>
      apiProvider.post('$basePath/$orderId/lines', body);

  Future<dynamic> updateLine(String orderId, String lineId, Map<String, dynamic> body) =>
      apiProvider.put('$basePath/$orderId/lines/$lineId', body: body);

  Future<dynamic> deleteLine(String orderId, String lineId) =>
      apiProvider.delete('$basePath/$orderId/lines/$lineId');

  // ── Receive Order (creates stock movements) ──────────────────────────────

  Future<dynamic> receiveOrder(String orderId) =>
      apiProvider.post('$basePath/$orderId/receive', {});
}