import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/theme/app_colors.dart';

enum AvatarSize { small, medium, large }

class PersonAvatar extends StatelessWidget {
  final String name;
  final int colorIndex;
  final AvatarSize size;

  const PersonAvatar({
    super.key,
    required this.name,
    required this.colorIndex,
    this.size = AvatarSize.medium,
  });

  double get _diameter => switch (size) {
        AvatarSize.small => 32,
        AvatarSize.medium => 40,
        AvatarSize.large => 56,
      };

  double get _fontSize => switch (size) {
        AvatarSize.small => 14,
        AvatarSize.medium => 18,
        AvatarSize.large => 24,
      };

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorForIndex(colorIndex);
    final letter = name.trim().isEmpty ? '?' : name.trim().characters.first;

    return Container(
      width: _diameter,
      height: _diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: GoogleFonts.cairo(
          fontSize: _fontSize,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}
