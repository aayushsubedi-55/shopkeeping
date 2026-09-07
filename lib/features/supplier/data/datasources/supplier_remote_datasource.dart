import 'package:shopnepal/core/network/http.dart';

/// Thin URI builder over the shared [ApiProvider]. No parsing, no error
/// handling — that is the repository's job.
class SupplierRemoteDataSource {
  final ApiProvider apiProvider;
  final String basePath = "suppliers";

  SupplierRemoteDataSource({required this.apiProvider});

  Future<dynamic> getAll() => apiProvider.get(basePath);

  Future<dynamic> getById(String id) => apiProvider.get('$basePath/$id');

  Future<dynamic> create(Map<String, dynamic> body) =>
      apiProvider.post(basePath, body);

  Future<dynamic> update(String id, Map<String, dynamic> body) =>
      apiProvider.put('$basePath/$id', body: body);

  Future<dynamic> delete(String id) => apiProvider.delete('$basePath/$id');
}
