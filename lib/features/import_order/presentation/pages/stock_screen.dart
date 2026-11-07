import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/widgets/page_wrapper.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/core/widgets/primary_button.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/domain/repositories/import_order_repository.dart';
import 'package:shopnepal/features/import_order/presentation/cubit/stock_cubit.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/stock_tile.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/stock_movement_sheet.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

@RoutePage()
class StockScreen extends StatelessWidget {
  const StockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StockCubit(
            repository: RepositoryProvider.of<ImportOrderRepository>(context),
          )..loadStock(),
        ),
        BlocProvider(
          create: (context) => StockMovementCubit(
            repository: RepositoryProvider.of<ImportOrderRepository>(context),
          ),
        ),
      ],
      child: const _StockScreenView(),
    );
  }
}

class _StockScreenView extends StatelessWidget {
  const _StockScreenView();

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: AppStrings.stock,
      body: RefreshIndicator(
        onRefresh: () => context.read<StockCubit>().loadStock(),
        child: BlocBuilder<StockCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(
                text: state.message,
                onRetry: () => context.read<StockCubit>().loadStock(),
              );
            }

            if (state is CommonDataFetchSuccess<StockOnHand>) {
              final stock = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: stock.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final item = stock[index];
                  return StockTile(
                    stock: item,
                    onTap: () => _showMovementSheet(context, productId: item.productId, size: item.size),
                  );
                },
              );
            }

            return const _ScrollableMessage(text: AppStrings.noStock);
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppInsets.all16,
          child: PrimaryButton(
            text: AppStrings.addStock,
            prefixIcon: Icons.add,
            onPressed: () => _showMovementSheet(context),
          ),
        ),
      ),
    );
  }

  void _showMovementSheet(BuildContext context, {String? productId, int? size}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (ctx) => StockMovementCubit(
          repository: RepositoryProvider.of<ImportOrderRepository>(sheetContext),
        ),
        child: StockMovementSheet(
          initialProductId: productId,
          initialSize: size,
        ),
      ),
    );
  }
}

/// Wraps the empty/error text in a scrollable, always-scrollable viewport so
/// pull-to-refresh keeps working even when there is nothing to list.
class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ThemeColors.midGrayColor,
                      fontSize: 14,
                    ),
                  ),
                  if (onRetry != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text(AppStrings.retry),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}