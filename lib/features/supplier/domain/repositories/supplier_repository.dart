import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';

abstract class SupplierRepository {
  Future<DataResponse<List<Supplier>>> getAll();

  Future<DataResponse<Supplier>> getById(String id);

  Future<DataResponse<Supplier>> create(Supplier item);

  Future<DataResponse<Supplier>> update(String id, Supplier item);

  Future<DataResponse<bool>> delete(String id);
}
