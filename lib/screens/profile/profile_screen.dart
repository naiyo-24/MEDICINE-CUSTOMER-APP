import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../providers/profile_provider.dart';
import '../../cards/profile/profile_header_card.dart';
import '../../cards/profile/profile_options_card.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        showBackButton: true,
        title: 'Profile',
        subtitle: 'Manage your personal info',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          children: [
            if (user != null) ...[
              ProfileHeaderCard(user: user),
              const SizedBox(height: AppSpacing.sectionGap),
            ],
            const ProfileOptionsCard(),
            const SizedBox(height: AppSpacing.sectionGap),
            const SizedBox(height: AppSpacing.sectionGap),
            const SizedBox(height: AppSpacing.sectionGap),
            const SizedBox(height: AppSpacing.sectionGap),
            const SizedBox(height: AppSpacing.sectionGap),
          ],
        ),
      ),
    );
  }
}
