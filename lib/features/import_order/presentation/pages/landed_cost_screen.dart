import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/widgets/page_wrapper.dart';
import 'package:shopnepal/core/widgets/common_loader.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/features/import_order/domain/repositories/import_order_repository.dart';
import 'package:shopnepal/features/import_order/presentation/cubit/stock_cubit.dart';
import 'package:shopnepal/features/import_order/presentation/widgets/landed_cost_tile.dart';
import 'package:shopnepal/core/theme/theme_colors.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

@RoutePage()
class LandedCostScreen extends StatelessWidget {
  final String? orderId;

  const LandedCostScreen({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandedCostCubit(
        repository: RepositoryProvider.of<ImportOrderRepository>(context),
      )..loadReport(orderId: orderId),
      child: _LandedCostScreenView(orderId: orderId),
    );
  }
}

class _LandedCostScreenView extends StatelessWidget {
  final String? orderId;

  const _LandedCostScreenView({this.orderId});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: AppStrings.landedCostReport,
      body: RefreshIndicator(
        onRefresh: () => context.read<LandedCostCubit>().refresh(orderId: orderId),
        child: BlocBuilder<LandedCostCubit, CommonState>(
          builder: (context, state) {
            if (state is CommonLoading || state is CommonInitial) {
              return const Center(child: CommonLoader());
            }

            if (state is CommonError) {
              return _ScrollableMessage(
                text: state.message,
                onRetry: () => context.read<LandedCostCubit>().refresh(orderId: orderId),
              );
            }

            if (state is CommonDataFetchSuccess<LandedCostLine>) {
              final lines = state.data;
              return ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: lines.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, index) {
                  final line = lines[index];
                  return LandedCostTile(line: line);
                },
              );
            }

            return const _ScrollableMessage(text: AppStrings.noData);
          },
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