import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../notifiers/cart_notifier.dart';

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
