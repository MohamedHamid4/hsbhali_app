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

class ShareablePersonCard extends StatelessWidget {
  final Bill bill;
  final PersonShare personShare;

  const ShareablePersonCard({
    super.key,
    required this.bill,
    required this.personShare,
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
    final phrase =
        ReceiptPhrases.pickFor('${bill.id}_${personShare.person.id}');
    final personColor =
        AppColors.avatarColorForIndex(personShare.person.colorIndex);

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
            color: personColor.withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _IndividualHeader(
              personShare: personShare,
              accent: personColor,
            ),
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
                  _DashedLine(color: personColor),
                  const SizedBox(height: AppDimensions.spacingSm),
                  _MetaRow(
                    icon: PhosphorIconsBold.mapPin,
                    text: placeName,
                    accent: personColor,
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  _MetaRow(
                    icon: PhosphorIconsBold.calendarDots,
                    text: bill.createdAt.formattedArabic,
                    accent: personColor,
                  ),
                  const SizedBox(height: AppDimensions.spacingMd),
                  _DashedLine(color: personColor),
                  const SizedBox(height: AppDimensions.spacingMd),

                  Row(
                    children: [
                      Icon(
                        PhosphorIconsBold.forkKnife,
                        color: personColor,
                        size: 18,
                      ),
                      const SizedBox(width: AppDimensions.spacingSm),
                      Text(
                        context.l10n.t('receipt_your_items'),
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSm),

                  if (personShare.items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacingSm,
                      ),
                      child: Text(
                        context.l10n.t('bill_no_items'),
                        style: GoogleFonts.cairo(
                          fontSize: 13,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    )
                  else
                    ...personShare.items.map(
                      (item) => _PersonItemRow(
                        item: item,
                        currency: currency,
                      ),
                    ),

                  const SizedBox(height: AppDimensions.spacingSm),
                  _DashedLine(color: personColor),
                  const SizedBox(height: AppDimensions.spacingSm),

                  _SummaryRow(
                    label: context.l10n.t('receipt_subtotal'),
                    value: personShare.subtotal,
                    currency: currency,
                  ),
                  if (personShare.taxShare > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_your_tax'),
                      value: personShare.taxShare,
                      currency: currency,
                    ),
                  if (personShare.tipShare > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_your_tip'),
                      value: personShare.tipShare,
                      currency: currency,
                    ),
                  if (personShare.serviceShare > 0)
                    _SummaryRow(
                      label: context.l10n.t('receipt_your_service'),
                      value: personShare.serviceShare,
                      currency: currency,
                    ),

                  const SizedBox(height: AppDimensions.spacingSm),

                  _TotalRow(
                    total: personShare.total,
                    currency: currency,
                    accent: personColor,
                    label: context.l10n.t('receipt_your_total'),
                  ),

                  const SizedBox(height: AppDimensions.spacingMd),
                  _DashedLine(color: personColor),
                  const SizedBox(height: AppDimensions.spacingLg),

                  _PhraseBlock(phrase: phrase),

                  const SizedBox(height: AppDimensions.spacingLg),
                  _DashedLine(color: personColor),
                  const SizedBox(height: AppDimensions.spacingMd),

                  _Footer(
                    label: context.l10n.t('receipt_thanks_footer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndividualHeader extends StatelessWidget {
  final PersonShare personShare;
  final Color accent;

  const _IndividualHeader({
    required this.personShare,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, accent.withValues(alpha: 0.78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingXl,
        AppDimensions.spacingLg,
        AppDimensions.spacingXl,
        AppDimensions.spacingLg,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(size: 28, isWhite: true),
              const SizedBox(width: AppDimensions.spacingSm),
              Text(
                'حسبهالي',
                style: GoogleFonts.marhey(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingMd),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PersonAvatar(
                name: personShare.person.name,
                colorIndex: personShare.person.colorIndex,
                size: AvatarSize.large,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Flexible(
                child: Text(
                  personShare.person.name,
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color accent;

  const _MetaRow({
    required this.icon,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accent),
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

class _PersonItemRow extends StatelessWidget {
  final BillItem item;
  final String currency;

  const _PersonItemRow({
    required this.item,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final assigned = item.assignedPersonIds;
    final shareCount = assigned.isEmpty ? 1 : assigned.length;
    final isShared = shareCount > 1;
    final pricePerPerson = item.totalPrice / shareCount;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (isShared)
                  Text(
                    context.l10n
                        .t('split_among')
                        .replaceAll('{count}', '$shareCount'),
                    style: GoogleFonts.cairo(
                      fontSize: 11,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            '×${item.quantity}',
            style: AppTextStyles.numberStyle(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingMd),
          Text(
            '${pricePerPerson.toStringAsFixed(2)} $currency',
            style: AppTextStyles.numberStyle(
              fontSize: 14,
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
  final Color accent;
  final String label;

  const _TotalRow({
    required this.total,
    required this.currency,
    required this.accent,
    required this.label,
  });

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
            accent.withValues(alpha: 0.10),
            AppColors.accent.withValues(alpha: 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIconsFill.coins,
            color: accent,
            size: 22,
          ),
          const SizedBox(width: AppDimensions.spacingSm),
          Text(
            label,
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
              color: accent,
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

class _DashedLine extends StatelessWidget {
  final Color color;

  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return DashedDivider(color: color.withValues(alpha: 0.3));
  }
}
