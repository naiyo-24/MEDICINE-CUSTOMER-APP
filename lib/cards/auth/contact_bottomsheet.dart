import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../theme/app_theme.dart';

class ContactBottomSheet extends StatelessWidget {
  const ContactBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Contact Support', style: AppTextStyles.subHeader),
          const SizedBox(height: 12),
          const Text(
            'Our team is here to help you 24/7.',
            style: AppTextStyles.description,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Iconsax.call, color: AppColors.primary),
            title: const Text('Call Us', style: AppTextStyles.cardTitle),
            subtitle: const Text('+91 1234567890', style: AppTextStyles.caption),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Iconsax.message, color: AppColors.primary),
            title: const Text('Email Us', style: AppTextStyles.cardTitle),
            subtitle: const Text('support@medy24.com', style: AppTextStyles.caption),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
