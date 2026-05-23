import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/charges_provider.dart';
import '../../theme/app_theme.dart';

class CartBillSummaryCard extends ConsumerWidget {
  const CartBillSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    if (cartState.items.isEmpty) return const SizedBox.shrink();

    final chargesState = ref.watch(chargesProvider);
    final summary = cartState.getSummary(chargesState.selectedCharge);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bill Summary', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          _buildRow('Item Total', summary.totalItemAmount),
          if (summary.totalDiscount > 0)
            _buildRow('Item Discount', -summary.totalDiscount, color: AppColors.success),
          _buildRow('Platform Fee', summary.platformCharges),
          _buildRow('Delivery Fee', summary.deliveryFees),
          _buildRow('Taxes', summary.taxes),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total to Pay', style: AppTextStyles.cardTitle),
              Text(
                '₹${summary.totalAmountToBePaid.toStringAsFixed(2)}',
                style: AppTextStyles.cardTitle.copyWith(color: AppColors.primaryAccent),
              ),
            ],
          ),
          if (summary.totalSaved > 0) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'You saved ₹${summary.totalSaved.toStringAsFixed(2)} on this order!',
                    style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(color: color ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
