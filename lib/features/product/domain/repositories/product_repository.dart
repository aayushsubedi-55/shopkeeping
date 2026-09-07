import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<DataResponse<List<Product>>> getAll();

  Future<DataResponse<Product>> getById(String id);

  Future<DataResponse<Product>> create(Product item);

  Future<DataResponse<Product>> update(String id, Product item);

  Future<DataResponse<bool>> delete(String id);
}
