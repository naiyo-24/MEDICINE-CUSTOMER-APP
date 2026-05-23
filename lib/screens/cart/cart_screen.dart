import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cart_provider.dart';
import '../../providers/charges_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/cart/cart_items_card.dart';
import '../../cards/cart/cart_bill_summary_card.dart';
import '../../cards/cart/cart_address_card.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(chargesProvider.notifier).fetchChargeByServiceType('parcel');
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    ref.watch(chargesProvider);
    final bool isCartEmpty = cartState.items.isEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Shopping Cart',
        subtitle: isCartEmpty
            ? 'Your cart is empty'
            : '${cartState.items.length} items',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            const CartItemsCard(),
            if (!isCartEmpty) ...[
              const SizedBox(height: AppSpacing.sectionGap),
              const CartBillSummaryCard(),
              const SizedBox(height: AppSpacing.sectionGap),
              const CartAddressCard(),
              const SizedBox(
                height: 100,
              ), // extra padding for bottom navigation
            ],
          ],
        ),
      ),
      bottomSheet: isCartEmpty
          ? null
          : Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.divider),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (cartState.selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an address first'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Processing Cash on Delivery...'),
                            ),
                          );
                        },
                        child: const Text('Pay COD'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          if (cartState.selectedAddress == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an address first'),
                              ),
                            );
                            return;
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Redirecting to Payment...'),
                            ),
                          );
                        },
                        child: const Text('Pay Online'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
