import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/lab_test.dart';
import '../../theme/app_theme.dart';

class LabTestBookingBottomSheet extends StatelessWidget {
  final LabTestInventoryModel test;
  final VoidCallback onConfirm;

  const LabTestBookingBottomSheet({
    super.key,
    required this.test,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required LabTestInventoryModel test,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LabTestBookingBottomSheet(
        test: test,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final testName = test.coreTestDetails?.testName ?? 'Lab Test';

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Confirm booking',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 8),
          Text(
            testName,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildPriceRow('Test price (MRP)', test.price),
          if (test.hasDiscount) ...[
            const SizedBox(height: 10),
            _buildPriceRow(
              'Discount (${test.discountPercent.toStringAsFixed(0)}%)',
              test.discountAmount,
              isDiscount: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.divider),
          ),
          _buildPriceRow('Total to pay', test.marketPrice, isTotal: true),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Confirm · ₹${test.marketPrice.toStringAsFixed(0)}'),
                  const SizedBox(width: 8),
                  const Icon(Iconsax.tick_circle, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              fontSize: isTotal ? 14 : 13,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          isDiscount
              ? '- ₹${amount.toStringAsFixed(0)}'
              : '₹${amount.toStringAsFixed(0)}',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: isTotal ? 18 : 14,
            color: isDiscount
                ? AppColors.error
                : isTotal
                    ? AppColors.primaryAccent
                    : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
