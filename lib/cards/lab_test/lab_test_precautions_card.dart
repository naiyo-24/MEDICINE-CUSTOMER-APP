import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';

class LabTestPrecautionsCard extends StatelessWidget {
  final LabTestInventoryModel test;

  const LabTestPrecautionsCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    final core = test.coreTestDetails;
    if (core == null || core.precautions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Important Precautions', Iconsax.warning_2),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7F7), // Very light red
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.error.withAlpha(50)),
            ),
            child: Column(
              children: core.precautions.map((precaution) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, size: 10, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          precaution.toString(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error.withAlpha(220),
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(30),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primaryAccent),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.cardTitle.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
