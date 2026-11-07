import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/utils/money_utils.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ImportOrderLineTile extends StatelessWidget {
  final ImportOrderLine line;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ImportOrderLineTile({
    super.key,
    required this.line,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.inventory_2, color: theme.colorScheme.primary),
        ),
        title: Text(
          'Product #${line.productId.substring(0, 8)}',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Cases: ${line.cases}  •  Pairs/Case: ${line.pairsPerCase}  •  Total Pairs: ${line.totalPairs}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              'Ratio: ${line.ratio.entries.map((e) => '${e.key}:${e.value}').join(', ')}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.s4),
            Text(
              '${line.priceBasis == 'per_case' ? 'Per Case' : 'Per Pair'}: ${MoneyUtils.formatCny(line.unitPrice)} ${line.currency}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: AppSpacing.s8),
                  Text(AppStrings.delete, style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}