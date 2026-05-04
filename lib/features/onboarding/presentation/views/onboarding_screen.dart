import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onNextPressed() async {
    final vm = ref.read(onboardingViewModelProvider.notifier);
    if (vm.isLastPage) {
      await _finishOnboarding();
    } else {
      await _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _onSkipPressed() async {
    await _finishOnboarding();
  }

  Future<void> _finishOnboarding() async {
    await ref.read(onboardingViewModelProvider.notifier).completeOnboarding();
    if (!mounted) return;
    context.go(RouteNames.main);
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(onboardingViewModelProvider);
    final isLast = currentPage == OnboardingViewModel.totalPages - 1;

    final pages = <Widget>[
      OnboardingPage(
        icon: PhosphorIconsBold.camera,
        illustrationColor: AppColors.primary,
        title: context.l10n.t('onboarding_1_title'),
        description: context.l10n.t('onboarding_1_desc'),
      ),
      OnboardingPage(
        icon: PhosphorIconsBold.usersThree,
        illustrationColor: AppColors.secondary,
        title: context.l10n.t('onboarding_2_title'),
        description: context.l10n.t('onboarding_2_desc'),
      ),
      OnboardingPage(
        icon: PhosphorIconsBold.shareNetwork,
        illustrationColor: AppColors.accent,
        title: context.l10n.t('onboarding_3_title'),
        description: context.l10n.t('onboarding_3_desc'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingLg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!isLast)
                      TextButton(
                        onPressed: _onSkipPressed,
                        child: Text(context.l10n.t('onboarding_skip')),
                      ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) {
                  ref
                      .read(onboardingViewModelProvider.notifier)
                      .updatePage(i);
                },
                children: pages,
              ),
            ),

            PageIndicator(
              totalPages: OnboardingViewModel.totalPages,
              currentPage: currentPage,
            ),

            const SizedBox(height: AppDimensions.spacingXl),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingXl,
              ),
              child: PrimaryButton(
                text: isLast
                    ? context.l10n.t('onboarding_start')
                    : context.l10n.t('onboarding_next'),
                onPressed: _onNextPressed,
              ),
            ),

            const SizedBox(height: AppDimensions.spacingXl),
          ],
        ),
      ),
    );
  }
}
