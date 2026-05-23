import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/my_test_booking.dart';
import '../../theme/app_theme.dart';
import 'my_booking_bottomsheet.dart';

class MyBookingCard extends StatelessWidget {
  final BookingDetailResponse booking;

  const MyBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.offline;
    IconData statusIcon = Iconsax.clock;
    if (booking.bookingStatus == 'pending') {
      statusColor = AppColors.warning;
      statusIcon = Iconsax.timer_1;
    } else if (booking.bookingStatus == 'completed') {
      statusColor = AppColors.success;
      statusIcon = Iconsax.verify;
    } else if (booking.bookingStatus == 'cancelled') {
      statusColor = AppColors.error;
      statusIcon = Iconsax.close_circle;
    }

    final String itemName = booking.bookedItems.isNotEmpty
        ? (booking.bookedItems.first['item_name'] ?? 'Lab Test')
        : 'Lab Test';
        
    final String itemSubtitle = booking.bookedItems.isNotEmpty
        ? (booking.bookedItems.first['item_subtitle'] ?? 'Lab Service')
        : 'Lab Service';

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.elementGap),
      decoration: AppCardStyles.sleekCard,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => MyBookingBottomSheet(booking: booking),
            );
          },
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Iconsax.microscope,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            itemName,
                            style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            itemSubtitle,
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            booking.bookingStatus.toUpperCase(),
                            style: AppTextStyles.tagline.copyWith(
                              color: statusColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: AppColors.divider.withAlpha(100), height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.hospital, size: 16, color: AppColors.textTertiary),
                        const SizedBox(width: 6),
                        Text(
                          booking.labName ?? 'N/A',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "₹${booking.totalAmountToBePaid}",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Iconsax.calendar, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 6),
                    Text(
                      booking.createdAt.toLocal().toString().split(' ')[0],
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
