import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LanguageCard extends StatefulWidget {
  final String character;
  final String languageName;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    super.key,
    required this.character,
    required this.languageName,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnimation = _controller.drive(Tween<double>(begin: 1.0, end: 0.95));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
          decoration: BoxDecoration(
            color: widget.isSelected ? AppColors.primaryPurple : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected 
                    ? AppColors.primaryPurple.withValues(alpha: 0.3) 
                    : AppColors.shadowColor,
                blurRadius: widget.isSelected ? 25 : 15,
                offset: widget.isSelected ? const Offset(0, 12) : const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: AppTextStyles.languageChar.copyWith(
                  color: widget.isSelected ? Colors.white : AppColors.textBlack,
                ),
                child: SizedBox(
                  width: 50.w,
                  child: Text(
                    widget.character,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: AppTextStyles.languageName.copyWith(
                    color: widget.isSelected ? Colors.white : AppColors.textBlack,
                    fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                  child: Text(
                    widget.languageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: widget.isSelected
                    ? Icon(
                        Icons.check_circle,
                        key: const ValueKey('check'),
                        color: Colors.white,
                        size: 24.sp,
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
