import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/product/data/datasources/product_remote_datasource.dart';
import 'package:shopnepal/features/product/data/models/product_model.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiProvider apiProvider;
  late ProductRemoteDataSource productRemoteDataSource;

  ProductRepositoryImpl({required this.apiProvider}) {
    productRemoteDataSource = ProductRemoteDataSource(
      apiProvider: apiProvider,
    );
  }

  @override
  Future<DataResponse<List<Product>>> getAll() async {
    try {
      final res = await productRemoteDataSource.getAll();
      final raw = res['data']?['data'];
      final list = raw is List ? raw : const <dynamic>[];

      final products = list
          .whereType<Map>()
          .map((e) => ProductModel.fromMap(Map<String, dynamic>.from(e)))
          .toList();

      return DataResponse.success(products);
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
  Future<DataResponse<Product>> getById(String id) async {
    try {
      final res = await productRemoteDataSource.getById(id);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid product payload');
      }
      return DataResponse.success(
        ProductModel.fromMap(Map<String, dynamic>.from(data)),
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
  Future<DataResponse<Product>> create(Product item) async {
    try {
      final body = ProductModel(
        id: '',
        articleNo: item.articleNo,
        nameCn: item.nameCn,
        nameEn: item.nameEn,
        supplierId: item.supplierId,
        imageUrl: item.imageUrl,
        defaultRatio: item.defaultRatio,
      ).toMap();

      final res = await productRemoteDataSource.create(body);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid product payload');
      }
      return DataResponse.success(
        ProductModel.fromMap(Map<String, dynamic>.from(data)),
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
  Future<DataResponse<Product>> update(String id, Product item) async {
    try {
      final body = ProductModel(
        id: id,
        articleNo: item.articleNo,
        nameCn: item.nameCn,
        nameEn: item.nameEn,
        supplierId: item.supplierId,
        imageUrl: item.imageUrl,
        defaultRatio: item.defaultRatio,
      ).toMap();

      final res = await productRemoteDataSource.update(id, body);
      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid product payload');
      }
      return DataResponse.success(
        ProductModel.fromMap(Map<String, dynamic>.from(data)),
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
      await productRemoteDataSource.delete(id);
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
