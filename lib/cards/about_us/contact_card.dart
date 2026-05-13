import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/about_us.dart';
import '../../theme/app_theme.dart';

class ContactCard extends StatelessWidget {
  final AboutUsModel aboutUs;

  const ContactCard({super.key, required this.aboutUs});

  @override
  Widget build(BuildContext context) {
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
                  Iconsax.call_calling,
                  color: AppColors.primaryAccent,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Get in Touch',
                style: AppTextStyles.cardTitle.copyWith(letterSpacing: -0.5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (aboutUs.officeAddress != null)
            _buildContactItem(
              icon: Iconsax.location,
              label: 'Office Address',
              value: aboutUs.officeAddress!,
            ),
          if (aboutUs.email1 != null)
            _buildContactItem(
              icon: Iconsax.sms,
              label: 'Email',
              value: aboutUs.email1!,
              value2: aboutUs.email2,
            ),
          if (aboutUs.phone1 != null)
            _buildContactItem(
              icon: Iconsax.call,
              label: 'Phone',
              value: aboutUs.phone1!,
              value2: aboutUs.phone2,
            ),
          if (aboutUs.website != null)
            _buildContactItem(
              icon: Iconsax.global_search,
              label: 'Website',
              value: aboutUs.website!,
              isLast: true,
            ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    String? value2,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.divider.withAlpha(50)),
            ),
            child: Icon(icon, size: 20, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (value2 != null)
                  Text(
                    value2,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
              ],
            ),
          ),
          Icon(Iconsax.arrow_right_3, size: 14, color: AppColors.divider),
        ],
      ),
    );
  }
}
