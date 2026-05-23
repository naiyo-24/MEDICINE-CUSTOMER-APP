class BookingDetailResponse {
  final String bookingId;
  final String customerId;
  final String labId;
  final String bookingType;
  final String bookingStatus;
  
  final List<dynamic> bookedItems;
  final List<dynamic> patientDetails;
  final Map<String, dynamic> sampleCollectionAddress;
  
  final List<String>? reportUrls;
  
  final double subTotalAmount;
  final double totalDiscountAmount;
  final double platformFee;
  final double taxAmount;
  final double totalAmountToBePaid;
  final double labPayableAmount;
  
  final String paymentMode;
  final String? transactionId;
  final String? transactionHash;
  final String transactionStatus;
  final double paidAmount;
  final DateTime? paidAt;
  
  final String? customerNote;
  final String? labNote;
  final String? cancellationReason;
  
  final DateTime createdAt;
  final DateTime updatedAt;
  
  final String? labName;
  final String? labAddress;
  final String? labPhone;
  final String? labEmail;

  BookingDetailResponse({
    required this.bookingId,
    required this.customerId,
    required this.labId,
    required this.bookingType,
    required this.bookingStatus,
    required this.bookedItems,
    required this.patientDetails,
    required this.sampleCollectionAddress,
    this.reportUrls,
    required this.subTotalAmount,
    required this.totalDiscountAmount,
    required this.platformFee,
    required this.taxAmount,
    required this.totalAmountToBePaid,
    required this.labPayableAmount,
    required this.paymentMode,
    this.transactionId,
    this.transactionHash,
    required this.transactionStatus,
    required this.paidAmount,
    this.paidAt,
    this.customerNote,
    this.labNote,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.labName,
    this.labAddress,
    this.labPhone,
    this.labEmail,
  });

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      bookingId: json['booking_id'] ?? '',
      customerId: json['customer_id'] ?? '',
      labId: json['lab_id'] ?? '',
      bookingType: json['booking_type'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      bookedItems: json['booked_items'] ?? [],
      patientDetails: json['patient_details'] ?? [],
      sampleCollectionAddress: json['sample_collection_address'] ?? {},
      reportUrls: json['report_urls'] != null ? List<String>.from(json['report_urls']) : null,
      subTotalAmount: _toDouble(json['sub_total_amount']),
      totalDiscountAmount: _toDouble(json['total_discount_amount']),
      platformFee: _toDouble(json['platform_fee']),
      taxAmount: _toDouble(json['tax_amount']),
      totalAmountToBePaid: _toDouble(json['total_amount_to_be_paid']),
      labPayableAmount: _toDouble(json['lab_payable_amount']),
      paymentMode: json['payment_mode'] ?? '',
      transactionId: json['transaction_id'],
      transactionHash: json['transaction_hash'],
      transactionStatus: json['transaction_status'] ?? '',
      paidAmount: _toDouble(json['paid_amount']),
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
      customerNote: json['customer_note'],
      labNote: json['lab_note'],
      cancellationReason: json['cancellation_reason'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      labName: json['lab_name'],
      labAddress: json['lab_address'],
      labPhone: json['lab_phone'],
      labEmail: json['lab_email'],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
