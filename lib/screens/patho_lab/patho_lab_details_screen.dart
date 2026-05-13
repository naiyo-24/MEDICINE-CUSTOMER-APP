import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../notifiers/lab_test_notifier.dart';
import '../../providers/lab_test_provider.dart';
import '../../providers/patho_lab_provider.dart';
import '../../theme/app_theme.dart';
import '../../cards/patho_lab/patho_lab_header_card.dart';
import '../../cards/patho_lab/test_package_toggle_bar.dart';
import '../../cards/lab_test/lab_test_card.dart';
import '../../cards/lab_test/package_card.dart';

class PathoLabDetailsScreen extends ConsumerStatefulWidget {
  final String labId;

  const PathoLabDetailsScreen({super.key, required this.labId});

  @override
  ConsumerState<PathoLabDetailsScreen> createState() =>
      _PathoLabDetailsScreenState();
}

class _PathoLabDetailsScreenState extends ConsumerState<PathoLabDetailsScreen> {
  bool _isPackageSelected = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pathoLabProvider.notifier).fetchLabById(widget.labId);
      ref.read(labTestProvider.notifier).fetchTestsByLab(widget.labId);
      ref.read(labTestProvider.notifier).fetchPackagesByLab(widget.labId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final labState = ref.watch(pathoLabProvider);
    final testState = ref.watch(labTestProvider);
    final lab = labState.selectedLab;

    if (labState.isLoading && lab == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (lab == null) {
      return Scaffold(
        body: Center(child: Text(labState.error ?? 'Laboratory not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            PathoLabHeaderCard(lab: lab, onBack: () => context.pop()),
            const SizedBox(height: 24),
            TestPackageToggleBar(
              isPackageSelected: _isPackageSelected,
              onToggle: (val) {
                setState(() {
                  _isPackageSelected = val;
                });
              },
            ),
            const SizedBox(height: 24),
            if (!_isPackageSelected)
              _buildTestsList(testState)
            else
              _buildPackagesList(testState),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTestsList(LabTestState testState) {
    if (testState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (testState.tests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                'No tests available for this lab',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: testState.tests.length,
      itemBuilder: (context, index) {
        final test = testState.tests[index];
        return LabTestCard(
          test: test,
          onTap: () {
            context.push('/lab-test-details/${test.testId}');
          },
        );
      },
    );
  }

  Widget _buildPackagesList(LabTestState testState) {
    if (testState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (testState.packages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              const Icon(
                Icons.card_giftcard,
                size: 48,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 12),
              Text(
                'No packages available yet',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      itemCount: testState.packages.length,
      itemBuilder: (context, index) {
        final package = testState.packages[index];
        return PackageCard(
          package: package,
          onTap: () {
            context.push('/test-package-details/${package.packageId}');
          },
        );
      },
    );
  }
}
