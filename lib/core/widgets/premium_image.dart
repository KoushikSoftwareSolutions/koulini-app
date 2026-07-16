import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class PremiumImage extends StatelessWidget {
  final String? imageUrl;
  final String? displayName;
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxFit fit;
  final bool isAvatar;

  const PremiumImage({
    super.key,
    required this.imageUrl,
    this.displayName,
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
      if (isAvatar && displayName != null && displayName!.trim().isNotEmpty) {
        final firstLetter = displayName!.trim().substring(0, 1).toUpperCase();
        final int colorCode = displayName!.codeUnits.fold(0, (prev, element) => prev + element);
        final List<Color> colors = [
          const Color(0xFF7C3AED),
          const Color(0xFFEF4444),
          const Color(0xFF3B82F6),
          const Color(0xFF10B981),
          const Color(0xFFF59E0B),
          const Color(0xFFEC4899),
          const Color(0xFF06B6D4),
        ];
        final Color avatarColor = colors[colorCode % colors.length];

        return ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius ?? 100.r),
          child: Container(
            width: width,
            height: height,
            color: avatarColor,
            alignment: Alignment.center,
            child: Text(
              firstLetter,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: (width != null && width!.isFinite) ? width! * 0.45 : 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }

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
