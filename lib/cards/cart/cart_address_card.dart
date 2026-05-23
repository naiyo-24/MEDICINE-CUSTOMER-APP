import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../providers/cart_provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_theme.dart';

class CartAddressCard extends ConsumerWidget {
  const CartAddressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    if (cartState.items.isEmpty) return const SizedBox.shrink();

    final profileState = ref.watch(profileProvider);
    final addresses = profileState.user?.savedAddresses ?? [];

    if (addresses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: AppCardStyles.sleekCard,
        child: const Row(
          children: [
            Icon(Iconsax.location, color: AppColors.error),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'No saved addresses found. Please add an address in your profile.',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: AppCardStyles.sleekCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Deliver To', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          ...addresses.map((address) {
            final isSelected = cartState.selectedAddress == address;
            return InkWell(
              onTap: () {
                ref.read(cartProvider.notifier).selectAddress(address);
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.divider,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? AppColors.primary.withAlpha(25)
                      : Colors.transparent,
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Iconsax.location_tick : Iconsax.location,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address['address_1'] ?? 'Address',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (address['street_address'] != null)
                            Text(
                              address['street_address'],
                              style: AppTextStyles.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
