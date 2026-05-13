import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/profile_notifier.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(ref);
});
