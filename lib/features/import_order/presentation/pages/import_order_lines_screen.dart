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
import 'package:shopnepal/features/import_order/presentation/widgets/import_order_line_tile.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/import_order_line_form_sheet.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

@RoutePage()
class ImportOrderLinesScreen extends StatelessWidget {
  final String orderId;

  const ImportOrderLinesScreen({super.key, @PathParam('orderId') required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImportOrderLinesCubit(
        repository: RepositoryProvider.of<ImportOrderRepository>(context),
      )..loadLines(orderId),
      child: _ImportOrderLinesScreenView(orderId: orderId),
    );
  }
}

class _ImportOrderLinesScreenView extends StatelessWidget {
  final String orderId;

  const _ImportOrderLinesScreenView({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: AppStrings.orderLines,
      body: RefreshIndicator(
        onRefresh: () => context.read<ImportOrderLinesCubit>().loadLines(orderId),
        child: BlocBuilder<ImportOrderLinesCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(
                text: state.message,
                onRetry: () => context.read<ImportOrderLinesCubit>().loadLines(orderId),
              );
            }

            if (state is CommonDataFetchSuccess<ImportOrderLine>) {
              final lines = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: lines.length + 1, // +1 for receive button
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  if (index == lines.length) {
                    return _buildReceiveButton(context);
                  }
                  final line = lines[index];
                  return ImportOrderLineTile(
                    line: line,
                    onTap: () => _showEditLineSheet(context, line),
                    onDelete: () => _deleteLine(context, line.id),
                  );
                },
              );
            }

            return const _ScrollableMessage(text: AppStrings.noOrderLines);
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppInsets.all16,
          child: PrimaryButton(
            text: AppStrings.addOrderLine,
            prefixIcon: Icons.add,
            onPressed: () => _showAddLineSheet(context),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiveButton(BuildContext context) {
    return BlocConsumer<ImportOrderLinesCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(AppStrings.receiveOrder)),
          );
          context.read<ImportOrderLinesCubit>().loadLines(orderId);
        } else if (state is CommonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CommonLoading;
        return PrimaryButton(
          text: isLoading ? AppStrings.receiving : AppStrings.receiveOrder,
          prefixIcon: Icons.inventory,
          onPressed: isLoading ? null : () => context.read<ImportOrderLinesCubit>().receiveOrder(),
        );
      },
    );
  }

  void _showAddLineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (ctx) => ImportOrderLinesCubit(
          repository: RepositoryProvider.of<ImportOrderRepository>(sheetContext),
        ),
        child: ImportOrderLineFormSheet(orderId: orderId, isEditing: false),
      ),
    );
  }

  void _showEditLineSheet(BuildContext context, ImportOrderLine line) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ThemeColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.s20)),
      ),
      builder: (sheetContext) => BlocProvider(
        create: (ctx) => ImportOrderLinesCubit(
          repository: RepositoryProvider.of<ImportOrderRepository>(sheetContext),
        ),
        child: ImportOrderLineFormSheet(orderId: orderId, isEditing: true, initialLine: line),
      ),
    );
  }

  void _deleteLine(BuildContext context, String lineId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteLine),
        content: const Text(AppStrings.confirmDeleteLine),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ImportOrderLinesCubit>().deleteLine(lineId);
            },
            child: Text(AppStrings.delete, style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
          ),
        ],
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