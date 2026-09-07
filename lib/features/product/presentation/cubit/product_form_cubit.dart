import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';

/// Create, update and delete for a single product — split out from
/// [ProductListCubit] the same way [SupplierFormCubit] splits from
/// `SupplierListCubit`.
class ProductFormCubit extends Cubit<CommonState> {
  final ProductRepository productRepository;

  ProductFormCubit({required this.productRepository}) : super(CommonInitial());

  Future<void> create({
    required String articleNo,
    String? nameCn,
    String? nameEn,
    required String supplierId,
    String? imageUrl,
  }) async {
    emit(CommonLoading());
    final res = await productRepository.create(
      Product(
        id: '',
        articleNo: articleNo,
        nameCn: nameCn,
        nameEn: nameEn,
        supplierId: supplierId,
        imageUrl: imageUrl,
      ),
    );
    _emitSaveResult(res);
  }

  Future<void> update(
    String id, {
    required String articleNo,
    String? nameCn,
    String? nameEn,
    required String supplierId,
    String? imageUrl,
  }) async {
    emit(CommonLoading());
    final res = await productRepository.update(
      id,
      Product(
        id: id,
        articleNo: articleNo,
        nameCn: nameCn,
        nameEn: nameEn,
        supplierId: supplierId,
        imageUrl: imageUrl,
      ),
    );
    _emitSaveResult(res);
  }

  Future<void> delete(String id) async {
    emit(CommonLoading());
    final res = await productRepository.delete(id);

    if (res.status == Status.success) {
      emit(CommonSuccess());
    } else {
      emit(CommonError(message: res.message ?? 'Unable to delete product'));
    }
  }

  void _emitSaveResult(DataResponse<Product> res) {
    if (res.status == Status.success && res.data != null) {
      emit(CommonStateSuccess<Product>(data: res.data as Product));
    } else {
      emit(
        CommonError(
          message: res.message ?? 'Unable to save product',
          statusCode: res.statusCode,
          code: res.code,
        ),
      );
    }
  }
}
