import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/domain/repositories/import_order_repository.dart';

/// Cubit for managing the list of import orders.
class ImportOrderListCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;

  ImportOrderListCubit({required this.repository}) : super(CommonInitial());

  Future<void> loadOrders() async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.getAll();

    if (res.status == Status.success) {
      final orders = res.data ?? const <ImportOrder>[];
      if (!isClosed) {
        emit(
          orders.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<ImportOrder>(data: orders),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load orders'));
    }
  }

  Future<void> refresh() => loadOrders();
}

/// Cubit for creating/updating a single import order.
class ImportOrderFormCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;

  ImportOrderFormCubit({required this.repository}) : super(CommonInitial());

  Future<void> createOrder(ImportOrderCreateInput input) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.create(input);

    if (res.status == Status.success && res.data != null) {
      if (!isClosed) emit(CommonStateSuccess<ImportOrder>(data: res.data!));
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to create order'));
    }
  }

  Future<void> updateOrder(String id, ImportOrderCreateInput input) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.update(id, input);

    if (res.status == Status.success && res.data != null) {
      if (!isClosed) emit(CommonStateSuccess<ImportOrder>(data: res.data!));
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to update order'));
    }
  }

  void reset() => emit(CommonInitial());
}

/// Cubit for managing order lines of a specific order.
class ImportOrderLinesCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;
  String? _currentOrderId;

  ImportOrderLinesCubit({required this.repository}) : super(CommonInitial());

  String? get currentOrderId => _currentOrderId;

  Future<void> loadLines(String orderId) async {
    _currentOrderId = orderId;
    if (!isClosed) emit(CommonLoading());
    final res = await repository.getLines(orderId);

    if (res.status == Status.success) {
      final lines = res.data ?? const <ImportOrderLine>[];
      if (!isClosed) {
        emit(
          lines.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<ImportOrderLine>(data: lines),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load order lines'));
    }
  }

  Future<void> addLine(ImportOrderLineCreateInput input) async {
    if (_currentOrderId == null) {
      if (!isClosed) emit(CommonError(message: 'No order selected'));
      return;
    }
    if (!isClosed) emit(CommonLoading());
    final res = await repository.createLine(_currentOrderId!, input);

    if (res.status == Status.success && res.data != null) {
      // Get current lines and add the new one
      final currentState = state;
      if (currentState is CommonDataFetchSuccess<ImportOrderLine>) {
        final updatedLines = [...currentState.data, res.data!];
        if (!isClosed) emit(CommonDataFetchSuccess<ImportOrderLine>(data: updatedLines));
      }
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to add line'));
    }
  }

  Future<void> updateLine(String lineId, ImportOrderLineCreateInput input) async {
    if (_currentOrderId == null) {
      if (!isClosed) emit(CommonError(message: 'No order selected'));
      return;
    }
    if (!isClosed) emit(CommonLoading());
    final res = await repository.updateLine(_currentOrderId!, lineId, input);

    if (res.status == Status.success && res.data != null) {
      final currentState = state;
      if (currentState is CommonDataFetchSuccess<ImportOrderLine>) {
        final updatedLines = currentState.data.map((l) => l.id == lineId ? res.data! : l).toList();
        if (!isClosed) emit(CommonDataFetchSuccess<ImportOrderLine>(data: updatedLines));
      }
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to update line'));
    }
  }

  Future<void> deleteLine(String lineId) async {
    if (_currentOrderId == null) {
      if (!isClosed) emit(CommonError(message: 'No order selected'));
      return;
    }
    if (!isClosed) emit(CommonLoading());
    final res = await repository.deleteLine(_currentOrderId!, lineId);

    if (res.status == Status.success) {
      final currentState = state;
      if (currentState is CommonDataFetchSuccess<ImportOrderLine>) {
        final updatedLines = currentState.data.where((l) => l.id != lineId).toList();
        if (!isClosed) {
          emit(updatedLines.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<ImportOrderLine>(data: updatedLines));
        }
      }
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to delete line'));
    }
  }

  Future<void> receiveOrder() async {
    if (_currentOrderId == null) {
      if (!isClosed) emit(CommonError(message: 'No order selected'));
      return;
    }
    if (!isClosed) emit(CommonLoading());
    final res = await repository.receiveOrder(_currentOrderId!);

    if (res.status == Status.success) {
      if (!isClosed) emit(CommonSuccess());
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to receive order'));
    }
  }

  void reset() {
    _currentOrderId = null;
    emit(CommonInitial());
  }
}