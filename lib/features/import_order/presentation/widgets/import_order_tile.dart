import 'package:flutter/material.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/utils/money_utils.dart';
import 'package:shopnepal/features/import_order/domain/entities/import_order.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ImportOrderTile extends StatelessWidget {
  final ImportOrder order;
  final VoidCallback onTap;

  const ImportOrderTile({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.1),
          child: Icon(_getStatusIcon(order.status), color: statusColor),
        ),
        title: Text(
          'Order #${order.id.substring(0, 8)}',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s2),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.s12),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (order.orderDate != null) ...[
                  const SizedBox(width: AppSpacing.s8),
                  Text(
                    'Order Date: ${order.orderDate!.day.toString().padLeft(2, '0')}/${order.orderDate!.month.toString().padLeft(2, '0')}/${order.orderDate!.year.toString()}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
            if (order.fxRateToNpr != null) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                'FX Rate: ${MoneyUtils.formatNpr(order.fxRateToNpr!)}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'ordered':
        return Colors.blue;
      case 'received':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Icons.edit;
      case 'ordered':
        return Icons.local_shipping;
      case 'received':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}