import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../providers/medicine_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/order_with_prescription_card.dart';
import '../../cards/medicine/medicine_card.dart';

class MedicineListScreen extends ConsumerStatefulWidget {
  const MedicineListScreen({super.key});

  @override
  ConsumerState<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends ConsumerState<MedicineListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(medicineProvider.notifier).fetchAllMedicines(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicines',
              style: AppTextStyles.header.copyWith(fontSize: 20),
            ),
            Text(
              'Order from your nearest pharmacy',
              style: AppTextStyles.tagline.copyWith(fontSize: 10),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/medicine-search'),
            icon: const Icon(
              Iconsax.search_normal_1,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: () {}, // Filter logic
            icon: const Icon(Iconsax.filter_edit, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(medicineProvider.notifier).fetchAllMedicines(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  16,
                  AppSpacing.screenPadding,
                  8,
                ),
                child: OrderWithPrescriptionCard(
                  onTap: () => context.push('/order-with-prescription'),
                ),
              ),
            ),
            if (medicineState.isLoading && medicineState.medicines.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (medicineState.error != null)
              SliverFillRemaining(
                child: Center(child: Text(medicineState.error!)),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    crossAxisSpacing: AppSpacing.elementGap,
                    mainAxisSpacing: AppSpacing.elementGap,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final medicine = medicineState.medicines[index];
                    return MedicineCard(
                      medicine: medicine,
                      onTap: () {
                        ref
                            .read(medicineProvider.notifier)
                            .selectMedicine(medicine);
                        context.push('/medicine-details');
                      },
                    );
                  }, childCount: medicineState.medicines.length),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Space for bottom nav
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {},
      ),
    );
  }
}
