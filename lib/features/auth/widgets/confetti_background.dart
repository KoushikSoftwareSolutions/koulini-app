import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfettiBackground extends StatelessWidget {
  const ConfettiBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.h,
      width: double.infinity,
      color: const Color(0xFFE8F5E9), // Light green from design
      child: Stack(
        children: [
          // Orange Dot
          Positioned(
            top: 60.h,
            left: 30.w,
            child: _buildDot(8.w, const Color(0xFFFF9800)),
          ),
          // Green Dot
          Positioned(
            top: 40.h,
            left: 80.w,
            child: _buildDot(10.w, const Color(0xFF4CAF50)),
          ),
          // Blue Dot
          Positioned(
            top: 80.h,
            right: 40.w,
            child: _buildDot(8.w, const Color(0xFF2196F3)),
          ),
          // Red Dot
          Positioned(
            top: 140.h,
            left: 50.w,
            child: _buildDot(8.w, const Color(0xFFF44336)),
          ),
          // Purple Dot
          Positioned(
            top: 150.h,
            right: 30.w,
            child: _buildDot(12.w, const Color(0xFF9C27B0)),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
