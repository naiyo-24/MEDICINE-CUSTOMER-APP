import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../models/my_test_booking.dart';
import '../../providers/lab_test_provider.dart';
import '../../theme/app_theme.dart';

class MyBookingBottomSheet extends ConsumerStatefulWidget {
  final BookingDetailResponse booking;

  const MyBookingBottomSheet({super.key, required this.booking});

  @override
  ConsumerState<MyBookingBottomSheet> createState() => _MyBookingBottomSheetState();
}

class _MyBookingBottomSheetState extends ConsumerState<MyBookingBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _cancelBooking() async {
    if (_reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a cancellation reason')),
      );
      return;
    }

    final success = await ref
        .read(labTestProvider.notifier)
        .cancelBooking(widget.booking.bookingId, _reasonController.text);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Booking cancelled successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.read(labTestProvider).error ?? 'Failed to cancel'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCancelled = widget.booking.bookingStatus == 'cancelled';
    final canCancel = widget.booking.bookingStatus == 'pending';

    final String patientName = widget.booking.patientDetails.isNotEmpty
        ? (widget.booking.patientDetails.first['full_name'] ?? 'N/A')
        : 'N/A';
        
    final String address = widget.booking.sampleCollectionAddress['address_1'] ?? 'N/A';
    
    Color statusColor = AppColors.offline;
    if (widget.booking.bookingStatus == 'pending') statusColor = AppColors.warning;
    if (widget.booking.bookingStatus == 'completed') statusColor = AppColors.success;
    if (widget.booking.bookingStatus == 'cancelled') statusColor = AppColors.error;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.borderRadius)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, controller) {
          return Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.screenPadding,
              right: AppSpacing.screenPadding,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sectionGap),
                Text(
                  'Booking Details',
                  style: AppTextStyles.header.copyWith(fontSize: 22),
                ),
                const SizedBox(height: AppSpacing.elementGap),
                Container(
                  decoration: AppCardStyles.sleekCard,
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    children: [
                      _buildDetailRow(Iconsax.receipt_item, 'Booking ID', widget.booking.bookingId),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.activity, 'Status', widget.booking.bookingStatus.toUpperCase(), valueColor: statusColor),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.hospital, 'Lab', widget.booking.labName ?? 'N/A'),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.user, 'Patient', patientName),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.location, 'Address', address),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.wallet, 'Total Amount', '₹${widget.booking.totalAmountToBePaid}', valueColor: AppColors.primaryAccent),
                      Divider(color: AppColors.divider.withAlpha(100)),
                      _buildDetailRow(Iconsax.card, 'Payment Mode', widget.booking.paymentMode.toUpperCase()),
                      
                      if (isCancelled && widget.booking.cancellationReason != null) ...[
                        Divider(color: AppColors.divider.withAlpha(100)),
                        _buildDetailRow(Iconsax.close_circle, 'Cancel Reason', widget.booking.cancellationReason!, valueColor: AppColors.error),
                      ],
                    ],
                  ),
                ),
                
                if (widget.booking.reportUrls != null && widget.booking.reportUrls!.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text('Reports', style: AppTextStyles.subHeader.copyWith(fontSize: 18)),
                  const SizedBox(height: AppSpacing.elementGap),
                  ...widget.booking.reportUrls!.map((url) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryAccent,
                            side: const BorderSide(color: AppColors.primaryAccent),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                          ),
                          icon: const Icon(Iconsax.document_download, size: 20),
                          label: const Text('Download Report', style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                 content: const Text('Downloading report...'),
                                 backgroundColor: AppColors.info,
                                 behavior: SnackBarBehavior.floating,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                               ),
                             );
                          },
                        ),
                      )),
                ],

                const SizedBox(height: AppSpacing.elementGap),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.divider),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadius)),
                  ),
                  icon: const Icon(Iconsax.receipt_2, size: 20),
                  label: const Text('Download Bill', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Downloading bill...'),
                        backgroundColor: AppColors.info,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                ),

                if (canCancel) ...[
                  const SizedBox(height: AppSpacing.sectionGap),
                  Text(
                    'Cancel Booking',
                    style: AppTextStyles.subHeader.copyWith(fontSize: 18, color: AppColors.error),
                  ),
                  const SizedBox(height: AppSpacing.elementGap),
                  TextField(
                    controller: _reasonController,
                    decoration: const InputDecoration(
                      hintText: 'Reason for cancellation',
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.elementGap),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorLight,
                        foregroundColor: AppColors.error,
                        elevation: 0,
                      ),
                      onPressed: _cancelBooking,
                      child: const Text('Confirm Cancellation'),
                    ),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textTertiary),
          const SizedBox(width: 8),
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
