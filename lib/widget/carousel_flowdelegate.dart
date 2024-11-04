import 'dart:math' as math; // Pastikan untuk mengimpor math
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // Semua lebar lukisan yang tersedia
    final size = context.size.width;

    // Ukuran untuk setiap item dalam tampilan
    final itemExtent = size / filtersPerScreen;

    // Posisi scroll saat ini yang dinyatakan sebagai pecahan item
    final active = viewportOffset.pixels / itemExtent;

    // Indeks item pertama yang perlu dilukis saat ini
    final min = math.max(0, active.floor() - 3).toInt();

    // Indeks item terakhir yang perlu dilukis saat ini
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Menghasilkan transformasi untuk item yang terlihat
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}