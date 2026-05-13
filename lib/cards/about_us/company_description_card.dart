import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class CompanyDescriptionCard extends StatelessWidget {
  final AboutUsModel aboutUs;

  const CompanyDescriptionCard({super.key, required this.aboutUs});

  @override
  Widget build(BuildContext context) {
    if (aboutUs.companyDescriptionText == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding * 1.5),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(30),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.status_up,
                  color: AppColors.primaryAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Our Story',
                style: AppTextStyles.cardTitle.copyWith(letterSpacing: -0.5),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            aboutUs.companyDescriptionText!,
            style: AppTextStyles.description.copyWith(
              color: AppColors.textPrimary.withAlpha(200),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
