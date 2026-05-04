import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final String? semanticsLabel;
  final bool isWhite;

  const AppLogo({
    super.key,
    this.size = 48,
    this.semanticsLabel,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/logo.svg',
      width: size,
      height: size,
      semanticsLabel: semanticsLabel ?? 'حسبهالي logo',
      fit: BoxFit.contain,
      colorFilter: isWhite
          ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
          : null,
    );
  }
}

class AppLogoSmall extends StatelessWidget {
  const AppLogoSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLogo(size: 32);
  }
}
