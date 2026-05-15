import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/settings_notifier.dart';

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);
