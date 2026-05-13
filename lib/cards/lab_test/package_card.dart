import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';
import '../../providers/patho_lab_provider.dart';

class PackageCard extends ConsumerWidget {
  final TestPackageModel package;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.package, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labState = ref.watch(pathoLabProvider);
    final lab = labState.labs.where((l) => l.labId == package.labId).firstOrNull;
    final labName = lab?.labName ?? 'Diagnostic Center';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: AppCardStyles.sleekCard,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'HEALTH PACKAGE',
                            style: AppTextStyles.tagline.copyWith(
                              fontSize: 9,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          package.packageName,
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildPriceSection(),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Iconsax.hospital, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      labName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildIncludesBadge(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹${package.packageFinalPrice.toStringAsFixed(0)}',
          style: AppTextStyles.header.copyWith(
            fontSize: 22,
            color: AppColors.primaryAccent,
          ),
        ),
        if (package.discountPercentage > 0)
          Row(
            children: [
              Text(
                '₹${package.packageMarketPrice.toStringAsFixed(0)}',
                style: AppTextStyles.caption.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${package.discountPercentage.toStringAsFixed(0)}% OFF',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildIncludesBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Iconsax.tick_circle, size: 12, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            '${package.testDetails.length} Tests Included',
            style: AppTextStyles.caption.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
