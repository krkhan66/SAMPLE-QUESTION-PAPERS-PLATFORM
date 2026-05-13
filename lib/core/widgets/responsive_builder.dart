import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          return desktop ?? tablet ?? mobile;
        }
        if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? mobilePadding;
  final EdgeInsetsGeometry? tabletPadding;
  final EdgeInsetsGeometry? desktopPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        EdgeInsetsGeometry padding;
        if (constraints.maxWidth >= AppConstants.desktopBreakpoint) {
          padding = desktopPadding ??
              const EdgeInsets.symmetric(horizontal: 64, vertical: 24);
        } else if (constraints.maxWidth >= AppConstants.tabletBreakpoint) {
          padding = tabletPadding ??
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
        } else {
          padding = mobilePadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        }
        return Padding(
          padding: padding,
          child: child,
        );
      },
    );
  }
}
