import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';
import 'package:shopnepal/features/product/domain/repositories/product_repository.dart';

class ProductListCubit extends Cubit<CommonState> {
  final ProductRepository productRepository;

  ProductListCubit({required this.productRepository}) : super(CommonInitial());

  Future<void> fetchAll() async {
    if (!isClosed) emit(CommonLoading());

    final res = await productRepository.getAll();

    if (res.status == Status.success) {
      final products = res.data ?? const <Product>[];
      if (!isClosed) {
        emit(
          products.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<Product>(data: products),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load products'));
    }
  }
}
