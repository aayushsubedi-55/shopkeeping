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
import 'package:shopnepal/features/import_order/presentation/cubit/import_order_cubit.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/import_order_tile.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/import_order_form_sheet.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/navigation/navigation.dart';

@RoutePage()
class ImportOrderScreen extends StatelessWidget {
  const ImportOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportOrderListCubit(
        repository: RepositoryProvider.of<ImportOrderRepository>(context),
      )..loadOrders(),
      child: const _ImportOrderScreenView(),
    );
  }
}

class _ImportOrderScreenView extends StatelessWidget {
  const _ImportOrderScreenView();

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: AppStrings.importOrders,
      body: RefreshIndicator(
        onRefresh: () => context.read<ImportOrderListCubit>().loadOrders(),
        child: BlocBuilder<ImportOrderListCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(
                text: state.message,
                onRetry: () => context.read<ImportOrderListCubit>().loadOrders(),
              );
            }

            if (state is CommonDataFetchSuccess<ImportOrder>) {
              final orders = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: orders.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return ImportOrderTile(
                    order: order,
                    onTap: () => _navigateToOrderLines(context, order),
                  );
                },
              );
            }

            return const _ScrollableMessage(text: AppStrings.noImportOrders);
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppInsets.all16,
          child: PrimaryButton(
            text: AppStrings.createOrder,
            prefixIcon: Icons.add,
            onPressed: () => _showCreateOrderSheet(context),
          ),
        ),
      ),
    );
  }

  void _showCreateOrderSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (ctx) => ImportOrderFormCubit(
          repository: RepositoryProvider.of<ImportOrderRepository>(sheetContext),
        ),
        child: const ImportOrderFormSheet(isEditing: false),
      ),
    );
  }

  void _navigateToOrderLines(BuildContext context, ImportOrder order) {
    context.router.push(ImportOrderLinesRoute(orderId: order.id));
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