import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/secondary_button.dart';
import '../../../people/presentation/widgets/person_chip.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/split_result.dart';
import '../providers/split_provider.dart';
import '../viewmodels/bill_details_viewmodel.dart';
import '../viewmodels/share_bill_viewmodel.dart';
import '../widgets/shareable_person_card.dart';
import '../widgets/shareable_receipt_card.dart';

class ShareBillScreen extends ConsumerStatefulWidget {
  final String billId;

  const ShareBillScreen({super.key, required this.billId});

  @override
  ConsumerState<ShareBillScreen> createState() => _ShareBillScreenState();
}

class _ShareBillScreenState extends ConsumerState<ShareBillScreen> {
  final GlobalKey _captureKey = GlobalKey();

  String _imageFilename() {
    final stamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    return 'hsbhali_$stamp';
  }

  Future<File> _captureImage() async {
    final boundary = _captureKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_imageFilename()}.png');
    await file.writeAsBytes(bytes);
    debugPrint('📤 Sharing receipt image: ${file.path} (${bytes.length} bytes)');
    return file;
  }

  Future<void> _shareImage() async {
    final vm = ref.read(shareBillViewModelProvider.notifier);
    final mode = ref.read(shareBillViewModelProvider).mode;
    vm.setGenerating(true);
    try {
      final file = await _captureImage();
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: context.l10n.t('share_bill_caption'),
      );
      await ref.read(analyticsServiceProvider).trackBillShared(
            mode: mode == ShareMode.group ? 'group' : 'individual',
          );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.t('share_failed'))),
        );
      }
    } finally {
      if (mounted) vm.setGenerating(false);
    }
  }

  Future<void> _saveToGallery() async {
    try {
      final file = await _captureImage();
      final length = await file.length();
      debugPrint('💾 Saving to gallery: ${file.path} ($length bytes)');

      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        await Gal.requestAccess(toAlbum: true);
      }
      await Gal.putImage(file.path, album: 'Hsbhali');
      debugPrint('💾 Saved to gallery album: Hsbhali');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('image_saved'))),
      );
    } catch (e) {
      debugPrint('💾 Save to gallery failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.t('permission_gallery_denied'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailsState = ref.watch(billDetailsViewModelProvider(widget.billId));

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.t('share_bill_title')),
      ),
      body: detailsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : detailsState.bill == null
              ? EmptyStateWidget(
                  icon: PhosphorIconsRegular.warning,
                  title: context.l10n.t('common_error'),
                  description: detailsState.errorMessage ?? '',
                )
              : _ShareContent(
                  bill: detailsState.bill!,
                  captureKey: _captureKey,
                  onShare: _shareImage,
                  onSave: _saveToGallery,
                ),
    );
  }
}

class _ShareContent extends ConsumerWidget {
  final Bill bill;
  final GlobalKey captureKey;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const _ShareContent({
    required this.bill,
    required this.captureKey,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSplit = ref.watch(splitResultProvider(bill));

    return asyncSplit.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => EmptyStateWidget(
        icon: PhosphorIconsRegular.warning,
        title: context.l10n.t('common_error'),
        description: e.toString(),
      ),
      data: (split) => _ShareBody(
        bill: bill,
        split: split,
        captureKey: captureKey,
        onShare: onShare,
        onSave: onSave,
      ),
    );
  }
}

class _ShareBody extends ConsumerWidget {
  final Bill bill;
  final SplitResult split;
  final GlobalKey captureKey;
  final VoidCallback onShare;
  final VoidCallback onSave;

  const _ShareBody({
    required this.bill,
    required this.split,
    required this.captureKey,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shareBillViewModelProvider);
    final vm = ref.read(shareBillViewModelProvider.notifier);

    PersonShare? selectedShare;
    if (state.mode == ShareMode.individual) {
      selectedShare = split.shares.firstWhere(
        (s) => s.person.id == state.selectedPersonId,
        orElse: () => split.shares.first,
      );
      if (state.selectedPersonId == null && split.shares.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.selectPerson(split.shares.first.person.id);
        });
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingLg,
            vertical: AppDimensions.spacingMd,
          ),
          child: Row(
            children: [
              Expanded(
                child: _ModeChip(
                  label: context.l10n.t('share_mode_group'),
                  icon: PhosphorIconsBold.users,
                  isSelected: state.mode == ShareMode.group,
                  onTap: () => vm.setMode(ShareMode.group),
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: _ModeChip(
                  label: context.l10n.t('share_mode_individual'),
                  icon: PhosphorIconsBold.user,
                  isSelected: state.mode == ShareMode.individual,
                  onTap: () => vm.setMode(ShareMode.individual),
                ),
              ),
            ],
          ),
        ),

        if (state.mode == ShareMode.individual)
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingLg,
              ),
              itemCount: split.shares.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: AppDimensions.spacingSm),
              itemBuilder: (_, i) {
                final share = split.shares[i];
                return Center(
                  child: PersonChip(
                    person: share.person,
                    isSelected: state.selectedPersonId == share.person.id,
                    onTap: () => vm.selectPerson(share.person.id),
                  ),
                );
              },
            ),
          ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacingLg),
            child: Center(
              child: RepaintBoundary(
                key: captureKey,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: state.mode == ShareMode.group
                      ? ShareableReceiptCard(bill: bill, split: split)
                      : ShareablePersonCard(
                          bill: bill,
                          personShare:
                              selectedShare ?? split.shares.first,
                        ),
                ),
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(
              top: BorderSide(color: context.colors.outlineVariant),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: context.l10n.t('save_to_gallery'),
                  icon: PhosphorIconsBold.downloadSimple,
                  onPressed: state.isGenerating ? null : onSave,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: PrimaryButton(
                  text: context.l10n.t('share_now'),
                  icon: PhosphorIconsBold.shareNetwork,
                  isLoading: state.isGenerating,
                  onPressed: state.isGenerating ? null : onShare,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingMd,
          horizontal: AppDimensions.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color:
                isSelected ? AppColors.primary : context.colors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconSmall,
              color: isSelected ? Colors.white : context.colors.onSurface,
            ),
            const SizedBox(width: AppDimensions.spacingSm),
            Text(
              label,
              style: context.textStyles.labelLarge?.copyWith(
                color:
                    isSelected ? Colors.white : context.colors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
