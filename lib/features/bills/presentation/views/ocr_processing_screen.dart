import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/extracted_receipt.dart';
import '../viewmodels/ocr_processing_viewmodel.dart';
import 'ocr_review_screen.dart';

class OcrProcessingScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const OcrProcessingScreen({super.key, required this.imagePath});

  @override
  ConsumerState<OcrProcessingScreen> createState() =>
      _OcrProcessingScreenState();
}

class _OcrProcessingScreenState extends ConsumerState<OcrProcessingScreen> {
  bool _dialogShown = false;
  bool _reviewOpened = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<OcrState>(
      ocrProcessingViewModelProvider(widget.imagePath),
      (previous, next) {
        if (next is OcrSuccess && !_reviewOpened) {
          _reviewOpened = true;
          ref
              .read(analyticsServiceProvider)
              .trackOcrUsed(success: true);
          _onSuccess(next.receipt);
        } else if (next is OcrError && !_dialogShown) {
          ref
              .read(analyticsServiceProvider)
              .trackOcrUsed(success: false);
          _onError();
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  child: Image.file(
                    File(widget.imagePath),
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      width: double.infinity,
                      color: context.colors.surfaceContainerHighest,
                      child: const Icon(
                        PhosphorIconsRegular.image,
                        size: AppDimensions.iconLarge,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingXxl),

                const CircularProgressIndicator(
                  color: AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.spacingLg),

                Text(
                  context.l10n.t('ocr_processing'),
                  style: context.textStyles.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  context.l10n.t('ocr_processing_desc'),
                  style: context.textStyles.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onSuccess(ExtractedReceipt receipt) async {
    if (!mounted) return;
    debugPrint(
      '🤖 OCR success → pushing review (items=${receipt.items.length})',
    );

    final navigator = Navigator.of(context);

    final reviewed = await navigator.push<ExtractedReceipt?>(
      MaterialPageRoute<ExtractedReceipt?>(
        builder: (_) => OcrReviewScreen(receipt: receipt),
      ),
    );

    debugPrint(
      '🔘 Review screen popped → reviewed=${reviewed == null ? 'null' : 'items=${reviewed.items.length}'}',
    );

    if (!mounted) return;
    navigator.pop(reviewed);
    debugPrint('🔘 OCR processing screen popped with result');
  }

  Future<void> _onError() async {
    _dialogShown = true;
    final action = await showDialog<_ErrorAction>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.t('ocr_failed_title')),
        content: Text(ctx.l10n.t('ocr_failed_desc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_ErrorAction.retry),
            child: Text(ctx.l10n.t('ocr_try_again')),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(_ErrorAction.manual),
            child: Text(ctx.l10n.t('ocr_manual_entry')),
          ),
        ],
      ),
    );

    if (!mounted) return;

    switch (action) {
      case _ErrorAction.retry:
        _dialogShown = false;
        ref
            .read(ocrProcessingViewModelProvider(widget.imagePath).notifier)
            .processImage(widget.imagePath);
        break;
      case _ErrorAction.manual:
        Navigator.of(context).pop(ExtractedReceipt.empty);
        break;
      case null:
        Navigator.of(context).pop();
        break;
    }
  }
}

enum _ErrorAction { retry, manual }
