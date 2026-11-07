import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/domain/repositories/import_order_repository.dart';

/// Cubit for stock on hand.
class StockCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;

  StockCubit({required this.repository}) : super(CommonInitial());

  Future<void> loadStock({String? productId}) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.getStock(productId: productId);

    if (res.status == Status.success) {
      final stock = res.data ?? const <StockOnHand>[];
      if (!isClosed) {
        emit(
          stock.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<StockOnHand>(data: stock),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load stock'));
    }
  }

  Future<void> refresh({String? productId}) => loadStock(productId: productId);
}

/// Cubit for creating stock movements (sale, adjustment, damage).
class StockMovementCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;

  StockMovementCubit({required this.repository}) : super(CommonInitial());

  Future<void> createMovement(StockMovementInput input) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.createStockMovement(input);

    if (res.status == Status.success && res.data != null) {
      if (!isClosed) emit(CommonStateSuccess<StockMovement>(data: res.data!));
    } else {
      if (!isClosed) emit(CommonError(message: res.message ?? 'Failed to record movement'));
    }
  }

  void reset() => emit(CommonInitial());
}

/// Cubit for landed cost report.
class LandedCostCubit extends Cubit<CommonState> {
  final ImportOrderRepository repository;

  LandedCostCubit({required this.repository}) : super(CommonInitial());

  Future<void> loadReport({String? orderId}) async {
    if (!isClosed) emit(CommonLoading());
    final res = await repository.getLandedCost(orderId: orderId);

    if (res.status == Status.success) {
      final lines = res.data ?? const <LandedCostLine>[];
      if (!isClosed) {
        emit(
          lines.isEmpty
              ? const CommonNoData()
              : CommonDataFetchSuccess<LandedCostLine>(data: lines),
        );
      }
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load report'));
    }
  }

  Future<void> refresh({String? orderId}) => loadReport(orderId: orderId);
}