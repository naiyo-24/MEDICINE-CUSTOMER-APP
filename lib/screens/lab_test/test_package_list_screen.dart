import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../providers/lab_test_provider.dart';
import '../../providers/patho_lab_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/lab_test/package_card.dart';

class TestPackageListScreen extends ConsumerStatefulWidget {
  const TestPackageListScreen({super.key});

  @override
  ConsumerState<TestPackageListScreen> createState() =>
      _TestPackageListScreenState();
}

class _TestPackageListScreenState extends ConsumerState<TestPackageListScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    Future.microtask(() async {
      // 1. Fetch labs first to know which labs to get packages from
      await ref.read(pathoLabProvider.notifier).fetchLabs(status: 'active');
      
      // 2. Get the list of lab IDs
      final labs = ref.read(pathoLabProvider).labs;
      final labIds = labs.map((l) => l.labId).toList();
      
      // 3. Fetch all packages for these labs
      if (labIds.isNotEmpty) {
        await ref.read(labTestProvider.notifier).fetchPackagesForLabs(labIds);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labTestState = ref.watch(labTestProvider);
    final packages = labTestState.packages
        .where(
          (p) =>
              p.packageName.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        showBackButton: true,
        title: _isSearching ? null : 'Health Packages',
        subtitle: _isSearching ? null : 'Comprehensive health checkups',
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Iconsax.close_circle : Iconsax.search_normal_1,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: 8,
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search packages...',
                  prefixIcon: const Icon(
                    Iconsax.search_normal,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          Expanded(
            child: labTestState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : packages.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: () => _loadData(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.screenPadding),
                      itemCount: packages.length,
                      itemBuilder: (context, index) {
                        final package = packages[index];
                        return PackageCard(
                          package: package,
                          onTap: () {
                            context.push(
                              '/test-package-details/${package.packageId}',
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.box_search, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No packages available'
                : 'No packages found for "$_searchQuery"',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
