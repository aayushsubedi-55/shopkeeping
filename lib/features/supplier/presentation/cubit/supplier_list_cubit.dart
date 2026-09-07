import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

class SupplierListCubit extends Cubit<CommonState> {
  final SupplierRepository supplierRepository;

  SupplierListCubit({required this.supplierRepository})
    : super(CommonInitial());

  Future<void> fetchAll() async {
    if (!isClosed) emit(CommonLoading());

    final res = await supplierRepository.getAll();

    if (res.status == Status.success) {
      final suppliers = res.data ?? const <Supplier>[];
      if (!isClosed) {
        emit(
          suppliers.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<Supplier>(data: suppliers),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load suppliers'));
    }
  }
}
