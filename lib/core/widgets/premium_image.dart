import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class PremiumImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;
  final bool isAvatar;

  const PremiumImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.isAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty && !imageUrl!.contains('pravatar.cc');

    if (!hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? (isAvatar ? 100.r : 16.r)),
        child: Container(
          width: width,
          height: height,
          color: const Color(0xFFF3F4F6),
          child: Icon(
            isAvatar ? Icons.person_rounded : Icons.image_not_supported_rounded,
            color: AppColors.textLightGray,
            size: (width != null && width!.isFinite) ? width! * 0.4 : 32.sp,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? (isAvatar ? 100.r : 16.r)),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: const Color(0xFFF3F4F6),
          highlightColor: Colors.white,
          child: Container(
            width: width,
            height: height,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          width: width,
          height: height,
          color: const Color(0xFFF3F4F6),
          child: Icon(
            isAvatar ? Icons.person_rounded : Icons.image_not_supported_rounded,
            color: AppColors.textLightGray,
            size: (width != null && width!.isFinite) ? width! * 0.4 : 32.sp,
          ),
        ),
      ),
    );
  }
}
