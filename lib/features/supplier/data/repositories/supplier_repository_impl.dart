import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/supplier/data/datasources/supplier_remote_datasource.dart';
import 'package:shopnepal/features/supplier/data/models/supplier_model.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final ApiProvider apiProvider;
  late SupplierRemoteDataSource supplierRemoteDataSource;

  SupplierRepositoryImpl({required this.apiProvider}) {
    supplierRemoteDataSource = SupplierRemoteDataSource(
      apiProvider: apiProvider,
    );
  }

  @override
  Future<DataResponse<List<Supplier>>> getAll() async {
    try {
      final res = await supplierRemoteDataSource.getAll();
      final raw = res['data']?['data'];
      final list = raw is List ? raw : const <dynamic>[];

      final suppliers = list
          .whereType<Map>()
          .map((e) => SupplierModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return DataResponse.success(suppliers);
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<Supplier>> getById(String id) async {
    try {
      final res = await supplierRemoteDataSource.getById(id);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid supplier payload');
      }
      return DataResponse.success(
        SupplierModel.fromMap(Map<String, dynamic>.from(data)),
      );
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<Supplier>> create(Supplier item) async {
    try {
      final body = SupplierModel(
        id: '',
        name: item.name,
        wechatId: item.wechatId,
      ).toMap();

      final res = await supplierRemoteDataSource.create(body);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid supplier payload');
      }
      return DataResponse.success(
        SupplierModel.fromMap(Map<String, dynamic>.from(data)),
      );
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<Supplier>> update(String id, Supplier item) async {
    try {
      final body = SupplierModel(
        id: id,
        name: item.name,
        wechatId: item.wechatId,
      ).toMap();

      final res = await supplierRemoteDataSource.update(id, body);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid supplier payload');
      }
      return DataResponse.success(
        SupplierModel.fromMap(Map<String, dynamic>.from(data)),
      );
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }

  @override
  Future<DataResponse<bool>> delete(String id) async {
    try {
      await supplierRemoteDataSource.delete(id);
      return DataResponse.success(true);
    } on CustomException catch (e) {
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
      );
    } catch (e) {
      return DataResponse.error(e.toString());
    }
  }
}
