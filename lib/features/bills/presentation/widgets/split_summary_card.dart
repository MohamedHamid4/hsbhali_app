import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../people/presentation/widgets/person_avatar.dart';
import '../../../people/presentation/widgets/whatsapp_button.dart';
import '../../domain/entities/split_result.dart';

class SplitSummaryCard extends StatefulWidget {
  final PersonShare share;
  final String currency;
  final String place;

  const SplitSummaryCard({
    super.key,
    required this.share,
    required this.currency,
    this.place = '',
  });

  @override
  State<SplitSummaryCard> createState() => _SplitSummaryCardState();
}

class _SplitSummaryCardState extends State<SplitSummaryCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.share;
    final color = AppColors.avatarColorForIndex(s.person.colorIndex);

    return CustomCard(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PersonAvatar(
                name: s.person.name,
                colorIndex: s.person.colorIndex,
                size: AvatarSize.large,
              ),
              const SizedBox(width: AppDimensions.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.person.name,
                      style: context.textStyles.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.t('owes'),
                      style: context.textStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    s.total.toStringAsFixed(2),
                    style: AppTextStyles.numberStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                  Text(
                    widget.currency,
                    style: context.textStyles.labelSmall,
                  ),
                ],
              ),
              const SizedBox(width: AppDimensions.spacingXs),
              WhatsAppButton(
                person: s.person,
                place: widget.place,
                amount: s.total,
                currency: widget.currency,
              ),
            ],
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _expanded ? _buildDetails(context) : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final s = widget.share;
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: context.colors.outlineVariant),
          if (s.items.isNotEmpty) ...[
            Text(
              context.l10n.t('view_items'),
              style: context.textStyles.labelMedium,
            ),
            const SizedBox(height: AppDimensions.spacingXs),
            ...s.items.map((i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${i.quantity}× ${i.name}',
                          style: context.textStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${i.totalPrice.toStringAsFixed(2)} ${widget.currency}',
                        style: AppTextStyles.numberStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )),
            const Divider(),
          ],
          _AmountRow(
            label: context.l10n.t('subtotal'),
            value: '${s.subtotal.toStringAsFixed(2)} ${widget.currency}',
          ),
          if (s.taxShare > 0)
            _AmountRow(
              label: context.l10n.t('tax_label'),
              value: '${s.taxShare.toStringAsFixed(2)} ${widget.currency}',
            ),
          if (s.tipShare > 0)
            _AmountRow(
              label: context.l10n.t('tip_label'),
              value: '${s.tipShare.toStringAsFixed(2)} ${widget.currency}',
            ),
          if (s.serviceShare > 0)
            _AmountRow(
              label: context.l10n.t('service_label'),
              value: '${s.serviceShare.toStringAsFixed(2)} ${widget.currency}',
            ),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final String value;
  const _AmountRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: context.textStyles.bodySmall),
          const Spacer(),
          Text(
            value,
            style: AppTextStyles.numberStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
