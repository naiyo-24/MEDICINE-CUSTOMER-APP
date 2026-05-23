import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/lab_test_provider.dart';
import '../../cards/lab_test/my_booking_card.dart';

class MyTestBookingsScreen extends ConsumerStatefulWidget {
  final String customerId;
  const MyTestBookingsScreen({super.key, required this.customerId});

  @override
  ConsumerState<MyTestBookingsScreen> createState() => _MyTestBookingsScreenState();
}

class _MyTestBookingsScreenState extends ConsumerState<MyTestBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(labTestProvider.notifier).fetchCustomerBookings(widget.customerId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labTestState = ref.watch(labTestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lab Tests & Packages'),
      ),
      body: labTestState.isBookingsLoading
          ? const Center(child: CircularProgressIndicator())
          : labTestState.bookingsError != null
              ? Center(child: Text(labTestState.bookingsError!))
              : labTestState.myBookings.isEmpty
                  ? const Center(child: Text("No bookings found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: labTestState.myBookings.length,
                      itemBuilder: (context, index) {
                        final booking = labTestState.myBookings[index];
                        return MyBookingCard(booking: booking);
                      },
                    ),
    );
  }
}
