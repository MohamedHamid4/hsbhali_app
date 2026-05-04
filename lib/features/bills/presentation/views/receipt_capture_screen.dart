import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/services/camera_service.dart';
import '../../../../core/services/image_compression_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';

class ReceiptCaptureScreen extends ConsumerStatefulWidget {
  const ReceiptCaptureScreen({super.key});

  @override
  ConsumerState<ReceiptCaptureScreen> createState() =>
      _ReceiptCaptureScreenState();
}

class _ReceiptCaptureScreenState extends ConsumerState<ReceiptCaptureScreen> {
  File? _capturedImage;
  bool _isProcessing = false;

  Future<void> _captureFromCamera() async {
    setState(() => _isProcessing = true);
    try {
      final file = await ref.read(cameraServiceProvider).captureFromCamera();
      if (!mounted) return;
      if (file == null) return;
      setState(() => _capturedImage = file);
    } catch (e) {
      if (!mounted) return;
      _showError(context.l10n.t('permission_camera_denied'));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isProcessing = true);
    try {
      final file = await ref.read(cameraServiceProvider).pickFromGallery();
      if (!mounted) return;
      if (file == null) return;
      setState(() => _capturedImage = file);
    } catch (e) {
      if (!mounted) return;
      _showError(context.l10n.t('permission_storage_denied'));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _useImage() async {
    final original = _capturedImage;
    if (original == null) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _isProcessing = true);
    final compressed = await ref
        .read(imageCompressionServiceProvider)
        .compressImage(original);
    if (!mounted) return;
    Navigator.of(context).pop(compressed.path);
  }

  void _retake() {
    setState(() => _capturedImage = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('capture_receipt')),
      ),
      body: SafeArea(
        child: _capturedImage == null
            ? _buildSourceSelection()
            : _buildPreview(),
      ),
    );
  }

  Widget _buildSourceSelection() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        children: [
          const Spacer(),
          _SourceCard(
            icon: PhosphorIconsBold.camera,
            color: AppColors.primary,
            title: context.l10n.t('capture_receipt'),
            onTap: _isProcessing ? null : _captureFromCamera,
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          _SourceCard(
            icon: PhosphorIconsBold.image,
            color: AppColors.secondary,
            title: context.l10n.t('choose_from_gallery'),
            onTap: _isProcessing ? null : _pickFromGallery,
          ),
          const Spacer(flex: 2),
          if (_isProcessing) const CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingLg),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: Image.file(
                _capturedImage!,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: context.l10n.t('retake'),
                  icon: PhosphorIconsBold.arrowCounterClockwise,
                  onPressed: _retake,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: PrimaryButton(
                  text: context.l10n.t('use_this_photo'),
                  icon: PhosphorIconsBold.check,
                  onPressed: _useImage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;

  const _SourceCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppDimensions.spacingXl),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: color, size: AppDimensions.iconLarge),
          ),
          const SizedBox(width: AppDimensions.spacingLg),
          Expanded(
            child: Text(
              title,
              style: context.textStyles.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }
}
