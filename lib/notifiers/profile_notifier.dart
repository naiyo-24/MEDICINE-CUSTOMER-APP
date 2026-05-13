import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  ProfileState({this.user, this.isLoading = false, this.error});

  ProfileState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileNotifier(this.ref) : super(ProfileState()) {
    _syncWithAuth();
  }

  void _syncWithAuth() {
    final authState = ref.watch(authProvider);
    if (authState.user != null) {
      state = state.copyWith(user: authState.user);
    }
  }

  Future<void> updateProfile({String? name, String? email}) async {
    state = state.copyWith(isLoading: true);
    // Mock update delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(name: name, email: email);
      state = state.copyWith(user: updatedUser, isLoading: false);
    }
  }
}
