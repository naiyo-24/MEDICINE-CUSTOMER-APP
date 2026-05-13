import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class MissionVisionCard extends StatelessWidget {
  final AboutUsModel aboutUs;

  const MissionVisionCard({super.key, required this.aboutUs});

  @override
  Widget build(BuildContext context) {
    if (aboutUs.mission == null && aboutUs.vision == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (aboutUs.mission != null)
          _buildCard(
            title: 'Our Mission',
            content: aboutUs.mission!,
            icon: Iconsax.direct_up,
            color: AppColors.primary,
          ),
        if (aboutUs.mission != null && aboutUs.vision != null)
          const SizedBox(height: 16),
        if (aboutUs.vision != null)
          _buildCard(
            title: 'Our Vision',
            content: aboutUs.vision!,
            icon: Iconsax.eye,
            color: AppColors.secondaryCyan,
          ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
      decoration: AppCardStyles.sleekCard,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 18,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: AppTextStyles.description.copyWith(
                    fontSize: 14,
                    height: 1.5,
                    color: AppColors.textPrimary.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
