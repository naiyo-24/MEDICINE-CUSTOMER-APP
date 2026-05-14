import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/medicine.dart';
import '../../theme/app_theme.dart';
import '../../services/api_url.dart';

class ShopBottomSheet extends StatelessWidget {
  final ShopDetails shop;

  const ShopBottomSheet({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.borderRadius * 1.5),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  // Handle
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.divider.withAlpha(150),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      children: [
                        // Shop Photo Card
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.cardRadius,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withAlpha(30),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.cardRadius,
                            ),
                            child: Stack(
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.6,
                                  child:
                                      shop.shopPhoto != null &&
                                          shop.shopPhoto!.isNotEmpty
                                      ? Image.network(
                                          ApiUrl.imageUrl(shop.shopPhoto),
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  _buildPlaceholder(),
                                        )
                                      : _buildPlaceholder(),
                                ),
                                // Gradient Overlay
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withAlpha(120),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Delivery Badge on Image
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Iconsax.truck_fast,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'EXPRESS DELIVERY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Delivery Wording
                        Center(
                          child: Text(
                            'Will be delivered within minutes from',
                            style: AppTextStyles.tagline.copyWith(
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Shop Name & Verified Icon
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              shop.shopName ?? 'Medy24 Partner',
                              style: AppTextStyles.header.copyWith(
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Iconsax.verify,
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Info Section Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: AppCardStyles.sleekCard,
                          child: Column(
                            children: [
                              _buildInfoRow(
                                icon: Iconsax.location,
                                title: 'Location',
                                value:
                                    shop.shopAddress ?? 'Address not available',
                              ),
                              const Divider(height: 32, thickness: 1),
                              _buildInfoRow(
                                icon: Iconsax.direct_right,
                                title: 'Distance',
                                value:
                                    'Within 2.5 km', // Placeholder for actual distance
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.cardSubtitle.copyWith(height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.divider,
      child: const Center(
        child: Icon(Iconsax.shop, size: 64, color: AppColors.textSecondary),
      ),
    );
  }
}
