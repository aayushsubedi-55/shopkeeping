import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/constants/app_strings.dart';
import 'package:shopnepal/core/utils/money_utils.dart';
import 'package:shopnepal/features/extraction/domain/entities/extraction.dart';
import 'package:shopnepal/features/extraction/presentation/cubit/extraction_cubit.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';

class ExtractionResultSheet extends StatelessWidget {
  final ExtractedSheet extractedSheet;

  const ExtractionResultSheet({super.key, required this.extractedSheet});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: AppSpacing.s8),
                Text(
                  AppStrings.extractedData,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            if (extractedSheet.supplierName != null) ...[
              _buildInfoRow(context, AppStrings.supplierName, extractedSheet.supplierName!),
              const SizedBox(height: AppSpacing.s8),
            ],
            if (extractedSheet.supplierWechat != null) ...[
              _buildInfoRow(context, AppStrings.supplierWechat, extractedSheet.supplierWechat!),
              const SizedBox(height: AppSpacing.s8),
            ],
            if (extractedSheet.notes != null) ...[
              _buildInfoRow(context, AppStrings.notes, extractedSheet.notes!),
              const SizedBox(height: AppSpacing.s16),
            ],
            Text(
              '${AppStrings.extractedProducts.replaceAll('%d', extractedSheet.products.length.toString())}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.s12),
            ...extractedSheet.products.map((product) => _buildProductCard(context, product)).toList(),
            const SizedBox(height: AppSpacing.s16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _onRetry(context),
                    icon: const Icon(Icons.refresh),
                    label: const Text(AppStrings.retakePhoto),
                  ),
                ),
                const SizedBox(width: AppSpacing.s12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _onCreateOrder(context),
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text(AppStrings.createOrderFromExtraction),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
        Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, ExtractedProduct product) {
    final theme = Theme.of(context);
    final confidenceColor = _getConfidenceColor(product.confidence);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.articleNo,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                  decoration: BoxDecoration(
                    color: confidenceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.s12),
                  ),
                  child: Text(
                    '${(product.confidence * 100).toInt()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: confidenceColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (product.nameCn != null || product.nameEn != null) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                product.nameEn ?? product.nameCn ?? '',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: AppSpacing.s8),
            Wrap(
              spacing: AppSpacing.s16,
              runSpacing: AppSpacing.s8,
              children: [
                _buildDetailChip(context, AppStrings.sizeRange, product.sizeRange),
                _buildDetailChip(context, AppStrings.cases, product.cases.toString()),
                _buildDetailChip(context, AppStrings.pairsPerCase, product.ratio.values.fold(0, (a, b) => a + b).toString()),
                _buildDetailChip(context, AppStrings.unitPricePerCase, '${MoneyUtils.formatCny(product.unitPrice)} ${product.currency}'),
                _buildDetailChip(context, AppStrings.priceBasis, product.priceBasis == 'per_case' ? AppStrings.perCase : AppStrings.perPair),
              ],
            ),
            if (product.ratio.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s8),
              Text(
                AppStrings.sizeRatio,
                style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: AppSpacing.s4),
              Wrap(
                spacing: AppSpacing.s8,
                children: product.ratio.entries.map((e) {
                  return Chip(
                    label: Text('Size ${e.key}: ${e.value}'),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.5) return Colors.orange;
    return Colors.red;
  }

  void _onRetry(BuildContext context) {
    BlocProvider.of<ExtractionCubit>(context).reset();
  }

  void _onCreateOrder(BuildContext context) {
    // TODO: Navigate to create order screen with pre-filled data from extraction
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Navigate to create order with extracted data')),
    );
  }
}