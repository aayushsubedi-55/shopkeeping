import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class MeasureSize extends SingleChildRenderObjectWidget {
  final ValueChanged<Size> onChange;

  const MeasureSize({super.key, required this.onChange, required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMeasureSize(onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class RenderMeasureSize extends RenderProxyBox {
  ValueChanged<Size> onChange;
  Size? _oldSize;

  RenderMeasureSize(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    final newSize = child?.size;
    if (newSize == null) return;

    if (_oldSize == newSize) return;
    _oldSize = newSize;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}
