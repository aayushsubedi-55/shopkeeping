import 'package:flutter/material.dart';
import 'package:shopnepal/core/theme/app_spacing.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/utils/card_boxshadow_utils.dart';
import 'package:shopnepal/features/supplier/domain/entities/supplier.dart';

class SupplierTile extends StatelessWidget {
  const SupplierTile({super.key, required this.supplier, this.onTap});

  final Supplier supplier;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final wechatId = supplier.wechatId?.trim();

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
                      supplier.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: ThemeColors.black,
                      ),
                    ),
                    if (wechatId != null && wechatId.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s4),
                      Text(
                        'WeChat: $wechatId',
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
