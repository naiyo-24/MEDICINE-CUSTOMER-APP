import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../models/medicine.dart';
import '../models/charges.dart';

class CartState {
  final List<CartItem> items;
  final dynamic selectedAddress;

  CartState({this.items = const [], this.selectedAddress});

  CartState copyWith({List<CartItem>? items, dynamic selectedAddress}) {
    return CartState(
      items: items ?? this.items,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }

  CartSummary getSummary(ChargesModel? charges) {
    double itemAmount = 0.0;
    double discount = 0.0;

    for (var item in items) {
      double mrp = item.medicine.mrp ?? 0.0;
      double finalPrice = item.medicine.finalPrice ?? mrp;

      itemAmount += mrp * item.quantity;
      discount += (mrp - finalPrice) * item.quantity;
    }

    double platformCharges = items.isEmpty
        ? 0.0
        : (charges?.platformCommission ?? 30.0);
    double deliveryFees = items.isEmpty ? 0.0 : (charges?.baseFare ?? 40.0);
    double subTotal = itemAmount - discount;
    double taxPercent = charges?.gstPercentage ?? 5.0;
    double taxes = subTotal * (taxPercent / 100);

    double totalToPay = items.isEmpty
        ? 0.0
        : subTotal + platformCharges + deliveryFees + taxes;

    return CartSummary(
      totalItemAmount: itemAmount,
      totalDiscount: discount,
      platformCharges: platformCharges,
      deliveryFees: deliveryFees,
      taxes: taxes,
      totalAmountToBePaid: totalToPay,
      totalSaved: discount,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState());

  void addItem(MedicineModel medicine) {
    final existingIndex = state.items.indexWhere(
      (item) => item.medicine.medicineId == medicine.medicineId,
    );

    if (existingIndex >= 0) {
      final updatedItems = [...state.items];
      final existingItem = updatedItems[existingIndex];
      updatedItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
      state = state.copyWith(items: updatedItems);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(medicine: medicine, quantity: 1),
        ],
      );
    }
  }

  void updateQuantity(String medicineId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(medicineId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.medicine.medicineId == medicineId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void removeItem(String medicineId) {
    state = state.copyWith(
      items: state.items
          .where((item) => item.medicine.medicineId != medicineId)
          .toList(),
    );
  }

  void selectAddress(dynamic address) {
    state = state.copyWith(selectedAddress: address);
  }

  void clearCart() {
    state = CartState(selectedAddress: state.selectedAddress);
  }
}
