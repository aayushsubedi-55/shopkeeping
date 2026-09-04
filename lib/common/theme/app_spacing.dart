import 'package:flutter/widgets.dart';

/// Centralized spacing/padding tokens for the app.
///
/// Rule of thumb: do not use numeric literals for padding/spacing in widgets.
/// Prefer `AppSpacing.s*` values instead.
abstract final class AppSpacing {
  static const double s0 = 0;
  static const double s1 = 1;
  static const double s2 = 2;
  static const double s3 = 3;
  static const double s4 = 4;
  static const double s5 = 5;
  static const double s6 = 6;
  static const double s7 = 7;
  static const double s8 = 8;
  static const double s9 = 9;
  static const double s10 = 10;
  static const double s11 = 11;
  static const double s12 = 12;
  static const double s13 = 13;
  static const double s14 = 14;
  static const double s15 = 15;
  static const double s16 = 16;
  static const double s18 = 18;
  static const double s20 = 20;
  static const double s22 = 22;
  static const double s24 = 24;
  static const double s26 = 26;
  static const double s28 = 28;
  static const double s30 = 30;
  static const double s32 = 32;
  static const double s36 = 36;
  static const double s40 = 40;
  static const double s44 = 44;
  static const double s48 = 48;
  static const double s50 = 50;
  static const double s56 = 56;
  static const double s60 = 60;
  static const double s64 = 64;
  static const double s72 = 72;
  static const double s80 = 80;
  static const double s92 = 92;
  static const double s100 = 100;
  static const double s120 = 120;
  static const double s140 = 140;
  static const double s160 = 160;
  static const double s180 = 180;
  static const double s200 = 200;
  static const double s220 = 220;
  static const double s240 = 240;
  static const double s260 = 260;
  static const double s280 = 280;
  static const double s300 = 300;
  static const double s320 = 320;
}

/// Convenience EdgeInsets to avoid repeating `EdgeInsets.*` patterns.
abstract final class AppInsets {
  static const EdgeInsets none = EdgeInsets.zero;

  static const EdgeInsets all4 = EdgeInsets.all(AppSpacing.s4);
  static const EdgeInsets all8 = EdgeInsets.all(AppSpacing.s8);
  static const EdgeInsets all10 = EdgeInsets.all(AppSpacing.s10);
  static const EdgeInsets all12 = EdgeInsets.all(AppSpacing.s12);
  static const EdgeInsets all14 = EdgeInsets.all(AppSpacing.s14);
  static const EdgeInsets all16 = EdgeInsets.all(AppSpacing.s16);
  static const EdgeInsets all18 = EdgeInsets.all(AppSpacing.s18);
  static const EdgeInsets all20 = EdgeInsets.all(AppSpacing.s20);
  static const EdgeInsets all24 = EdgeInsets.all(AppSpacing.s24);

  static const EdgeInsets h10 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s10,
  );
  static const EdgeInsets h12 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s12,
  );
  static const EdgeInsets h14 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s14,
  );
  static const EdgeInsets h16 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s16,
  );
  static const EdgeInsets h18 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s18,
  );
  static const EdgeInsets h20 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s20,
  );
  static const EdgeInsets h24 = EdgeInsets.symmetric(
    horizontal: AppSpacing.s24,
  );

  static const EdgeInsets v8 = EdgeInsets.symmetric(vertical: AppSpacing.s8);
  static const EdgeInsets v10 = EdgeInsets.symmetric(vertical: AppSpacing.s10);
  static const EdgeInsets v12 = EdgeInsets.symmetric(vertical: AppSpacing.s12);
  static const EdgeInsets v14 = EdgeInsets.symmetric(vertical: AppSpacing.s14);
  static const EdgeInsets v16 = EdgeInsets.symmetric(vertical: AppSpacing.s16);
  static const EdgeInsets v18 = EdgeInsets.symmetric(vertical: AppSpacing.s18);
  static const EdgeInsets v20 = EdgeInsets.symmetric(vertical: AppSpacing.s20);
}

/// Centralized radius tokens for the app.
///
/// Rule of thumb: do not use numeric literals for corner radius in widgets.
/// Prefer `AppRadius.r*` / `AppBorderRadius.*` instead.
abstract final class AppRadius {
  static const double r0 = AppSpacing.s0;
  static const double r2 = AppSpacing.s2;
  static const double r4 = AppSpacing.s4;
  static const double r6 = AppSpacing.s6;
  static const double r8 = AppSpacing.s8;
  static const double r10 = AppSpacing.s10;
  static const double r12 = AppSpacing.s12;
  static const double r14 = AppSpacing.s14;
  static const double r16 = AppSpacing.s16;
  static const double r18 = AppSpacing.s18;
  static const double r20 = AppSpacing.s20;
  static const double r24 = AppSpacing.s24;
}

/// Convenience `BorderRadius` values to keep radius usage consistent.
abstract final class AppBorderRadius {
  static const BorderRadius none = BorderRadius.zero;

  static const BorderRadius all2 = BorderRadius.all(
    Radius.circular(AppRadius.r2),
  );
  static const BorderRadius all4 = BorderRadius.all(
    Radius.circular(AppRadius.r4),
  );
  static const BorderRadius all6 = BorderRadius.all(
    Radius.circular(AppRadius.r6),
  );
  static const BorderRadius all8 = BorderRadius.all(
    Radius.circular(AppRadius.r8),
  );
  static const BorderRadius all10 = BorderRadius.all(
    Radius.circular(AppRadius.r10),
  );
  static const BorderRadius all12 = BorderRadius.all(
    Radius.circular(AppRadius.r12),
  );
  static const BorderRadius all14 = BorderRadius.all(
    Radius.circular(AppRadius.r14),
  );
  static const BorderRadius all16 = BorderRadius.all(
    Radius.circular(AppRadius.r16),
  );
  static const BorderRadius all20 = BorderRadius.all(
    Radius.circular(AppRadius.r20),
  );
  static const BorderRadius all24 = BorderRadius.all(
    Radius.circular(AppRadius.r24),
  );
}
