import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/bills/domain/entities/bill.dart';
import '../../features/bills/domain/entities/extracted_receipt.dart';
import '../../features/bills/presentation/views/bill_details_screen.dart';
import '../../features/bills/presentation/views/bills_list_screen.dart';
import '../../features/bills/presentation/views/create_bill_screen.dart';
import '../../features/bills/presentation/views/edit_bill_screen.dart';
import '../../features/bills/presentation/views/ocr_processing_screen.dart';
import '../../features/bills/presentation/views/ocr_review_screen.dart';
import '../../features/bills/presentation/views/receipt_capture_screen.dart';
import '../../features/bills/presentation/views/share_bill_screen.dart';
import '../../features/bills/presentation/views/split_result_screen.dart';
import '../../features/insights/presentation/views/monthly_insights_screen.dart';
import '../../features/legal/presentation/views/privacy_policy_screen.dart';
import '../../features/legal/presentation/views/terms_of_service_screen.dart';
import '../../features/main_navigation/presentation/views/main_navigation_screen.dart';
import '../../features/onboarding/presentation/views/onboarding_screen.dart';
import '../../features/people/presentation/views/shillas_list_screen.dart';
import '../../features/quick_calculate/presentation/views/quick_calculate_screen.dart';
import '../../features/settings/presentation/views/about_screen.dart';
import '../../features/splash/presentation/views/animated_splash_screen.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const AnimatedSplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.main,
        name: 'main',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: RouteNames.quickCalculate,
        name: 'quickCalculate',
        builder: (context, state) => const QuickCalculateScreen(),
      ),

      GoRoute(
        path: RouteNames.bills,
        name: 'bills',
        builder: (context, state) => const BillsListScreen(),
      ),
      GoRoute(
        path: RouteNames.createBill,
        name: 'createBill',
        builder: (context, state) => const CreateBillScreen(),
      ),
      GoRoute(
        path: '${RouteNames.billDetails}/:id',
        name: 'billDetails',
        builder: (context, state) =>
            BillDetailsScreen(billId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '${RouteNames.editBill}/:id',
        name: 'editBill',
        builder: (context, state) =>
            EditBillScreen(billId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '${RouteNames.splitResult}/:id',
        name: 'splitResult',
        builder: (context, state) =>
            SplitResultScreen(billId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: RouteNames.receiptCapture,
        name: 'receiptCapture',
        builder: (context, state) => const ReceiptCaptureScreen(),
      ),

      GoRoute(
        path: RouteNames.ocrProcessing,
        name: 'ocrProcessing',
        builder: (context, state) {
          final imagePath = state.extra as String;
          return OcrProcessingScreen(imagePath: imagePath);
        },
      ),
      GoRoute(
        path: RouteNames.ocrReview,
        name: 'ocrReview',
        builder: (context, state) {
          final receipt = state.extra as ExtractedReceipt;
          return OcrReviewScreen(receipt: receipt);
        },
      ),

      GoRoute(
        path: '${RouteNames.shareBill}/:id',
        name: 'shareBill',
        builder: (context, state) =>
            ShareBillScreen(billId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: RouteNames.shillas,
        name: 'shillas',
        builder: (context, state) => const ShillasListScreen(),
      ),

      GoRoute(
        path: RouteNames.monthlyInsights,
        name: 'monthlyInsights',
        builder: (context, state) => const MonthlyInsightsScreen(),
      ),

      GoRoute(
        path: RouteNames.repeatBill,
        name: 'repeatBill',
        builder: (context, state) {
          final template = state.extra as Bill;
          return CreateBillScreen(templateBill: template);
        },
      ),

      GoRoute(
        path: RouteNames.about,
        name: 'about',
        builder: (context, state) => const AboutScreen(),
      ),

      GoRoute(
        path: RouteNames.privacyPolicy,
        name: 'privacyPolicy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: RouteNames.termsOfService,
        name: 'termsOfService',
        builder: (context, state) => const TermsOfServiceScreen(),
      ),
    ],
  );
});
