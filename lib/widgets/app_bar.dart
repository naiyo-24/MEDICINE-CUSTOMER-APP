import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? subtitle;
  final bool showLogo;
  final bool showBackButton;
  final List<Widget>? actions;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.showLogo = false,
    this.showBackButton = false,
    this.actions,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withAlpha(240), // Slightly more opaque
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading Section: Logo or Back Button
            if (showBackButton)
              GestureDetector(
                onTap:
                    onBackTap ??
                    () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        // Fallback if there's nothing to pop
                        context.go('/home');
                      }
                    },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Iconsax.arrow_left_2,
                    size: 20,
                    color: Colors.grey.shade700,
                  ),
                ),
              )
            else if (showLogo)
              Container(
                height: 44,
                width: 44,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/logo/logo.png',
                  fit: BoxFit.contain,
                ),
              ),

            const SizedBox(width: 16),

            // Title and Subtitle Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: AppTextStyles.subHeader.copyWith(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Actions Section
            if (actions != null)
              IconTheme(
                data: IconThemeData(color: Colors.grey.shade600, size: 24),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!
                      .map(
                        (action) => Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: action,
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(88);
}
