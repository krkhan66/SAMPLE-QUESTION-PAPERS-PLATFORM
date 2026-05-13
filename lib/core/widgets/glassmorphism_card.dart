import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class GlassmorphismCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blurIntensity;
  final double opacity;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const GlassmorphismCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius = AppDimensions.radiusLg,
    this.blurIntensity = 10,
    this.opacity = 0.15,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDark ? AppColors.glassDark : AppColors.glassLight;
    final borderColor =
        isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: blurIntensity,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: opacity > 0
              ? null
              : null, // Kept for glassmorphism pattern
          child: Container(
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            padding: padding ?? const EdgeInsets.all(AppDimensions.md),
            child: onTap != null
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(borderRadius),
                      onTap: onTap,
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
