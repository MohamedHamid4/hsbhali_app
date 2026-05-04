import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/receipt_phrases.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../people/presentation/widgets/person_avatar.dart';
import '../../domain/entities/bill.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/entities/split_result.dart';
import 'dashed_divider.dart';

class ShareableReceiptCard extends StatelessWidget {
  final Bill bill;
  final SplitResult split;

  const ShareableReceiptCard({
    super.key,
    required this.bill,
    required this.split,
  });

  String _currencyLabel(BuildContext context) => bill.currency == 'EGP'
      ? context.l10n.t('common_currency_egp')
      : context.l10n.t('common_currency_usd');

  @override
  Widget build(BuildContext context) {
    final currency = _currencyLabel(context);
    final placeName = bill.placeName?.trim().isNotEmpty == true
        ? bill.placeName!
        : context.l10n.t('bill_untitled');
    final phrase = ReceiptPhrases.pickFor(bill.id);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: Container(
        width: 380,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BrandedHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spacingXl,
                AppDimensions.spacingMd,
                AppDimensions.spacingXl,
                AppDimensions.spacingXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ReceiptDashed(),
                  const SizedBox(height: AppDimensions.spacingSm),
                  _MetaRow(
                    icon: PhosphorIconsBold.mapPin,
                    text: placeName,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  _MetaRow(
                    icon: PhosphorIconsBold.calendarDots,
                    text: bill.createdAt.formattedArabic,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  const _ReceiptDashed(),
                  const SizedBox(height: AppDimensions.spacingMd),

                  Row(
                    children: [
                      const Icon(
                        PhosphorIconsBold.usersThree,
                        color: AppColors.primary,
                        size: 18,
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      Text(
                        context.l10n.t('receipt_participants'),
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),

                  ...split.shares.map(
                    (share) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spacingMd,
                      ),
                      child: _PersonCard(
                        share: share,
                        currency: currency,
                      ),
                    ),
                  ),

                  const _ReceiptDashed(),
                  const SizedBox(height: AppDimensions.spacingSm),

                  if (bill.taxAmount > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_tax'),
                      value: bill.taxAmount,
                      currency: currency,
                    ),
                  if (bill.tipAmount > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_tip'),
                      value: bill.tipAmount,
                      currency: currency,
                    ),
                  if (bill.serviceCharge > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_service'),
                      value: bill.serviceCharge,
                      currency: currency,
                    ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  _TotalRow(total: bill.total, currency: currency),

                  const SizedBox(height: AppDimensions.spacingMd),
                  const _ReceiptDashed(),
                  const SizedBox(height: AppDimensions.spacingLg),

                  _PhraseBlock(phrase: phrase),

                  const SizedBox(height: AppDimensions.spacingLg),
                  const _ReceiptDashed(),
                  const SizedBox(height: AppDimensions.spacingMd),

                  _Footer(label: context.l10n.t('receipt_thanks_footer')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandedHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXl,
        vertical: AppDimensions.spacingLg,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppLogo(size: 44, isWhite: true),
          const SizedBox(width: AppDimensions.spacingMd),
          Text(
            'حسبهالي',
            style: GoogleFonts.marhey(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.95),
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: const Icon(
              PhosphorIconsFill.receipt,
              color: AppColors.lightTextPrimary,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: AppDimensions.spacingSm),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _PersonCard extends StatelessWidget {
  final PersonShare share;
  final String currency;

  const _PersonCard({required this.share, required this.currency});

  @override
  Widget build(BuildContext context) {
    final personColor =
        AppColors.avatarColorForIndex(share.person.colorIndex);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              PersonAvatar(
                name: share.person.name,
                colorIndex: share.person.colorIndex,
                size: AvatarSize.small,
              ),
              const SizedBox(width: AppDimensions.spacingSm),
              Expanded(
                child: Text(
                  share.person.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${share.total.toStringAsFixed(2)} $currency',
                style: AppTextStyles.numberStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: personColor,
                ),
              ),
            ],
          ),
          if (share.items.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacingSm),
            ...share.items.map(
              (item) => _PersonItemRow(
                item: item,
                personId: share.person.id,
                currency: currency,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PersonItemRow extends StatelessWidget {
  final BillItem item;
  final String personId;
  final String currency;

  const _PersonItemRow({
    required this.item,
    required this.personId,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final assigned = item.assignedPersonIds;
    final shareCount = assigned.isEmpty ? 1 : assigned.length;
    final pricePerPerson = item.totalPrice / shareCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Text(
            '•',
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Expanded(
            child: Text(
              item.name,
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: AppColors.lightTextSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${pricePerPerson.toStringAsFixed(2)} $currency',
            style: AppTextStyles.numberStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final String currency;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const Spacer(),
          Text(
            '${value.toStringAsFixed(2)} $currency',
            style: AppTextStyles.numberStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final double total;
  final String currency;

  const _TotalRow({required this.total, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingMd,
        vertical: AppDimensions.spacingMd,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.10),
            AppColors.accent.withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            PhosphorIconsFill.coins,
            color: AppColors.primaryDark,
            size: 22,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            context.l10n.t('receipt_total'),
            style: GoogleFonts.cairo(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const Spacer(),
          Text(
            '${total.toStringAsFixed(2)} $currency',
            style: AppTextStyles.numberStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhraseBlock extends StatelessWidget {
  final String phrase;

  const _PhraseBlock({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsFill.chatCircleText,
            color: AppColors.accentDark,
            size: 18,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Expanded(
            child: Text(
              phrase,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: AppColors.lightTextPrimary,
                height: 1.5,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final String label;

  const _Footer({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            PhosphorIconsFill.handshake,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptDashed extends StatelessWidget {
  const _ReceiptDashed();

  @override
  Widget build(BuildContext context) {
    return DashedDivider(
      color: AppColors.primary.withValues(alpha: 0.3),
    );
  }
}
