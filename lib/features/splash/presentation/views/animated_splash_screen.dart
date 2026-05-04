import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers/preferences_provider.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_logo.dart';

const Color _splashBackground = Color(0xFF0F6E56);

class AnimatedSplashScreen extends ConsumerStatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  ConsumerState<AnimatedSplashScreen> createState() =>
      _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends ConsumerState<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final isFirstTime = ref.read(preferencesServiceProvider).isFirstTime();
      context.go(isFirstTime ? RouteNames.onboarding : RouteNames.main);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _splashBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(size: 140, isWhite: true),
                const SizedBox(height: AppDimensions.spacingXl),
                const Text(
                  AppConstants.appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  context.l10n.t('app_tagline'),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
