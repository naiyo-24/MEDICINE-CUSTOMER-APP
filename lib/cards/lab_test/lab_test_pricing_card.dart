import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';

class LabTestPricingCard extends StatelessWidget {
  final LabTestInventoryModel test;

  const LabTestPricingCard({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Pricing', Iconsax.wallet_3),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.divider.withAlpha(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildPriceRow('Test price (MRP)', test.price),
                if (test.hasDiscount) ...[
                  const SizedBox(height: 12),
                  _buildPriceRow(
                    'Discount (${test.discountPercent.toStringAsFixed(0)}%)',
                    test.discountAmount,
                    isDiscount: true,
                  ),
                ],
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(height: 1, color: AppColors.divider),
                ),
                _buildPriceRow(
                  'Total to pay',
                  test.marketPrice,
                  isTotal: true,
                ),
              ],
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

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isTotal = false,
    Color? valueColor,
  }) {
    final formattedAmount = isDiscount
        ? '- ₹${amount.toStringAsFixed(0)}'
        : '₹${amount.toStringAsFixed(0)}';

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: (isTotal ? AppTextStyles.bodyMedium : AppTextStyles.caption)
                .copyWith(
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              fontSize: isTotal ? 15 : 13,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          formattedAmount,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            fontSize: isTotal ? 18 : 14,
            color: valueColor ??
                (isDiscount
                    ? AppColors.error
                    : isTotal
                        ? AppColors.primaryAccent
                        : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
