import 'medicine.dart';

class CartItem {
  final MedicineModel medicine;
  final int quantity;

  CartItem({
    required this.medicine,
    required this.quantity,
  });

  CartItem copyWith({
    MedicineModel? medicine,
    int? quantity,
  }) {
    return CartItem(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartSummary {
  final double totalItemAmount;
  final double totalDiscount;
  final double platformCharges;
  final double deliveryFees;
  final double taxes;
  final double totalAmountToBePaid;
  final double totalSaved;

  CartSummary({
    required this.totalItemAmount,
    required this.totalDiscount,
    required this.platformCharges,
    required this.deliveryFees,
    required this.taxes,
    required this.totalAmountToBePaid,
    required this.totalSaved,
  });
}
