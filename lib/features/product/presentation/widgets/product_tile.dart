import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/utils/card_boxshadow_utils.dart';
import 'package:shopnepal/features/product/domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = (product.nameEn?.trim().isNotEmpty ?? false)
        ? product.nameEn!.trim()
        : product.nameCn?.trim();

    return Material(
      color: ThemeColors.white,
      borderRadius: AppShapes.radiusXl,
      child: InkWell(
        borderRadius: AppShapes.radiusXl,
        onTap: onTap,
        child: Container(
          padding: AppInsets.all16,
          decoration: BoxDecoration(
            borderRadius: AppShapes.radiusXl,
            boxShadow: [CardBoxShadowUtils.cardBoxShadow],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.articleNo,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.black,
                      ),
                    ),
                    if (name != null && name.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: ThemeColors.lightTextColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: ThemeColors.midGrayColor),
            ],
          ),
        ),
      ),
    );
  }
}
