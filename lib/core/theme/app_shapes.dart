import 'package:flutter/material.dart';

/// Semantic corner-radius tokens for the app.
///
/// Prefer these over numeric `BorderRadius.circular(...)` literals so radius
/// can be tuned globally from one place.
abstract final class AppShapes {
  static const double xs = 4;
  static const double sm = 6;

  /// Default cards, inputs, and theme buttons.
  static const double md = 8;

  /// Larger cards and grouped surfaces.
  static const double lg = 10;

  /// Sheets and medium containers.
  static const double xl = 12;

  /// Product / cart cards.
  static const double xxl = 14;

  /// Tab chips and compact pills.
  static const double chip = 18;

  /// Full-width pill buttons and category chips.
  static const double pill = 20;

  /// Floating bars and prominent CTAs.
  static const double bar = 22;

  /// Banner / hero image corners.
  static const double banner = 20;

  /// Large floating checkout bars.
  static const double floating = 28;

  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius radiusChip = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius radiusBar = BorderRadius.all(Radius.circular(bar));
  static const BorderRadius radiusBanner =
      BorderRadius.all(Radius.circular(banner));
  static const BorderRadius radiusFloating =
      BorderRadius.all(Radius.circular(floating));

  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );

  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );

  static const RoundedRectangleBorder pillShape = RoundedRectangleBorder(
    borderRadius: radiusPill,
  );

  static const RoundedRectangleBorder dialogShape = RoundedRectangleBorder(
    borderRadius: radiusMd,
  );
}
