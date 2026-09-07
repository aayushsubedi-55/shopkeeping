import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

/// Create, update and delete for a single supplier — split out from
/// [SupplierListCubit] the same way auth splits `LoginCubit` from
/// `GetMeCubit`: one cubit per operation family rather than one cubit for
/// the whole feature.
class SupplierFormCubit extends Cubit<CommonState> {
  final SupplierRepository supplierRepository;

  SupplierFormCubit({required this.supplierRepository})
    : super(CommonInitial());

  Future<void> create({required String name, String? wechatId}) async {
    emit(CommonLoading());
    final res = await supplierRepository.create(
      Supplier(id: '', name: name, wechatId: wechatId),
    );
    _emitSaveResult(res);
  }

  Future<void> update(
    String id, {
    required String name,
    String? wechatId,
  }) async {
    emit(CommonLoading());
    final res = await supplierRepository.update(
      id,
      Supplier(id: id, name: name, wechatId: wechatId),
    );
    _emitSaveResult(res);
  }

  Future<void> delete(String id) async {
    emit(CommonLoading());
    final res = await supplierRepository.delete(id);

    if (res.status == Status.success) {
      emit(CommonSuccess());
    } else {
      emit(CommonError(message: res.message ?? 'Unable to delete supplier'));
    }
  }

  void _emitSaveResult(DataResponse<Supplier> res) {
    if (res.status == Status.success && res.data != null) {
      emit(CommonStateSuccess<Supplier>(data: res.data as Supplier));
    } else {
      emit(
        CommonError(
          message: res.message ?? 'Unable to save supplier',
          statusCode: res.statusCode,
          code: res.code,
        ),
      );
    }
  }
}
