import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../providers/about_us_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';
import '../../cards/about_us/company_header_card.dart';
import '../../cards/about_us/company_description_card.dart';
import '../../cards/about_us/mission_vision_card.dart';
import '../../cards/about_us/director_message_card.dart';
import '../../cards/about_us/partner_card.dart';
import '../../cards/about_us/contact_card.dart';

class AboutUsScreen extends ConsumerWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aboutUsState = ref.watch(aboutUsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'About Us',
        subtitle: 'COMPANY INFORMATION',
        showBackButton: true,
      ),
      body: _buildBody(context, ref, aboutUsState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, dynamic aboutUsState) {
    if (aboutUsState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      );
    }

    if (aboutUsState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.danger, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Oops! Something went wrong', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Text(aboutUsState.error!, style: AppTextStyles.caption),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(aboutUsProvider.notifier).fetchAboutUs(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    if (aboutUsState.aboutUsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document_filter,
              size: 64,
              color: AppColors.textTertiary.withAlpha(100),
            ),
            const SizedBox(height: 16),
            Text('No Information Found', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any company details.',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      );
    }

    final data = aboutUsState.aboutUsList.first;

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => ref.read(aboutUsProvider.notifier).fetchAboutUs(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
          vertical: AppSpacing.screenPadding,
        ),
        child: Column(
          children: [
            CompanyHeaderCard(aboutUs: data),
            const SizedBox(height: 20),
            CompanyDescriptionCard(aboutUs: data),
            const SizedBox(height: 20),
            MissionVisionCard(aboutUs: data),
            const SizedBox(height: 20),
            DirectorMessageCard(aboutUs: data),
            const SizedBox(height: 20),
            PartnerCard(aboutUs: data),
            const SizedBox(height: 20),
            ContactCard(aboutUs: data),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
