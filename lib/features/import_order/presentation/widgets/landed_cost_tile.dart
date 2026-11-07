import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/utils/money_utils.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class LandedCostTile extends StatelessWidget {
  final LandedCostLine line;

  const LandedCostTile({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.receipt_long, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product #${line.productId.substring(0, 8)}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Order #${line.orderId.substring(0, 8)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            _buildInfoRow(
              context,
              AppStrings.cases,
              line.cases.toString(),
              AppStrings.pairsPerCase,
              line.pairsPerCase.toString(),
            ),
            _buildInfoRow(
              context,
              AppStrings.totalPairs,
              line.pairs.toString(),
              AppStrings.goodsCny,
              MoneyUtils.formatCny(line.goodsCny),
            ),
            _buildInfoRow(
              context,
              AppStrings.goodsNpr,
              MoneyUtils.formatNpr(line.goodsNpr),
              AppStrings.overheadNpr,
              MoneyUtils.formatNpr(line.overheadNpr),
            ),
            const Divider(height: AppSpacing.s24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.landedCostPerPair,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  MoneyUtils.formatNpr(line.landedCostPerPairNpr),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label1,
    String value1,
    String label2,
    String value2,
  ) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(value1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label2, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(value2, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}