import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../providers/lab_test_provider.dart';
import '../../theme/app_theme.dart';
import '../../cards/lab_test/lab_test_header_card.dart';
import '../../cards/lab_test/lab_test_description_parameter_card.dart';
import '../../cards/lab_test/lab_test_sample_report_card.dart';
import '../../cards/lab_test/lab_test_precautions_card.dart';
import '../../cards/lab_test/lab_test_reviews_card.dart';

class LabTestDetailsScreen extends ConsumerStatefulWidget {
  final String testId;

  const LabTestDetailsScreen({super.key, required this.testId});

  @override
  ConsumerState<LabTestDetailsScreen> createState() => _LabTestDetailsScreenState();
}

class _LabTestDetailsScreenState extends ConsumerState<LabTestDetailsScreen> {
  late ScrollController _scrollController;
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    Future.microtask(() {
      ref.read(labTestProvider.notifier).fetchTestById(widget.testId);
    });
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final isCollapsed = _scrollController.offset > (350 - kToolbarHeight - 50);
      if (isCollapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = isCollapsed;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labTestState = ref.watch(labTestProvider);
    final test = labTestState.selectedTest;

    if (labTestState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (test == null) {
      return Scaffold(
        body: Center(child: Text(labTestState.error ?? 'Test not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Header with SliverAppBar
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            stretch: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: _isCollapsed ? Colors.transparent : Colors.black.withAlpha(50),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.arrow_left_2,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isCollapsed ? 1.0 : 0.0,
              child: Text(
                test.coreTestDetails?.testName ?? 'Test Details',
                style: AppTextStyles.header.copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              background: LabTestHeaderCard(test: test),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 32),
                LabTestDescriptionParameterCard(test: test),
                LabTestSampleReportCard(test: test),
                LabTestPrecautionsCard(test: test),
                LabTestReviewsCard(test: test),
                const SizedBox(height: 120), // Bottom padding for button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBookingBar(test),
      extendBody: true,
    );
  }

  Widget _buildBottomBookingBar(dynamic test) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 30,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price to pay',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${test.marketPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.header.copyWith(
                          fontSize: 26,
                          color: AppColors.primaryAccent,
                        ),
                      ),
                      if (test.discountPercent > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${test.price.toStringAsFixed(0)}',
                          style: AppTextStyles.caption.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 56,
              width: 160,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.primary.withAlpha(100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Book Now'),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.arrow_right_3, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
