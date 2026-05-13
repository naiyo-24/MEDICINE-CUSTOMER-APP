import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      state = state.copyWith(user: UserModel.fromJson(userJson));
    }
  }

  Future<void> login(String phoneNumber) async {
    state = state.copyWith(isLoading: true);
    // Mock OTP sending delay
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(isLoading: false);
    // In a real app, you'd store the phone number to use during verification
  }

  Future<void> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);
    // Mock verification delay
    await Future.delayed(const Duration(seconds: 2));

    final user = UserModel(
      id: '1',
      phoneNumber: '9876543210',
      name: 'Rajdeep Dey',
      token: 'mock_token',
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user.toJson());

    state = state.copyWith(user: user, isLoading: false);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    state = AuthState();
  }
}
