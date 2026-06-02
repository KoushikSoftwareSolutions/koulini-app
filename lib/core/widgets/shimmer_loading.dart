import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF3F4F6),
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }

  // Pre-configured shimmer for text lines
  static Widget textLine({double? width, double height = 14}) {
    return ShimmerLoading(
      width: width ?? double.infinity,
      height: height.h,
      borderRadius: 4,
    );
  }

  // Pre-configured shimmer for avatars
  static Widget avatar({double size = 56}) {
    return ShimmerLoading(
      width: size.w,
      height: size.w,
      borderRadius: size,
    );
  }
}
