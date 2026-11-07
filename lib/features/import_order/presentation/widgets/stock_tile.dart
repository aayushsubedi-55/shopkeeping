import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class StockTile extends StatelessWidget {
  final StockOnHand stock;
  final VoidCallback onTap;

  const StockTile({
    super.key,
    required this.stock,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLowStock = stock.pairs < 10;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: isLowStock ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
          child: Icon(
            isLowStock ? Icons.warning : Icons.inventory,
            color: isLowStock ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          'Product #${stock.productId.substring(0, 8)}',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Size: ${stock.size}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Pairs: ${stock.pairs}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isLowStock ? Colors.red : theme.colorScheme.onSurface,
              ),
            ),
            if (isLowStock) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                AppStrings.lowStock,
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.red),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}