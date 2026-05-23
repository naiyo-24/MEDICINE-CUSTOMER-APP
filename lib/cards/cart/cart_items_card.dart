import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/cart.dart';
import '../../providers/cart_provider.dart';
import '../../theme/app_theme.dart';

class CartItemsCard extends ConsumerWidget {
  const CartItemsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);

    if (cartState.items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppCardStyles.sleekCard,
        child: Center(
          child: Column(
            children: [
              const Icon(Iconsax.shopping_cart, size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 12),
              Text('Your cart is empty', style: AppTextStyles.cardTitle.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: AppCardStyles.sleekCard,
      child: Column(
        children: cartState.items.map((item) {
          return _buildCartItem(context, ref, item);
        }).toList(),
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, WidgetRef ref, CartItem item) {
    final medicine = item.medicine;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: medicine.medicinePhoto != null
                ? Image.network(medicine.medicinePhoto!, fit: BoxFit.cover)
                : const Icon(Iconsax.box, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.medicineName ?? 'Unknown Medicine',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.medicineQuantity ?? '',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '₹${medicine.finalPrice?.toStringAsFixed(2) ?? medicine.mrp?.toStringAsFixed(2) ?? ''}',
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (medicine.finalPrice != null && medicine.mrp != null && medicine.finalPrice! < medicine.mrp!) ...[
                      const SizedBox(width: 8),
                      Text(
                        '₹${medicine.mrp?.toStringAsFixed(2)}',
                        style: AppTextStyles.caption.copyWith(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Iconsax.minus, size: 16),
                  onPressed: () {
                    ref.read(cartProvider.notifier).updateQuantity(medicine.medicineId!, item.quantity - 1);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
                Text(
                  '${item.quantity}',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Iconsax.add, size: 16),
                  onPressed: () {
                    ref.read(cartProvider.notifier).updateQuantity(medicine.medicineId!, item.quantity + 1);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
