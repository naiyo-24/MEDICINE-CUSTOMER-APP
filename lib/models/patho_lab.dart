class PathoLabModel {
  final String labId;
  final String labName;
  final String mobileNumber;
  final String emailAddress;
  final String? gstNumber;
  final String panNumber;
  final String nablAccreditationNumber;
  final String address;
  final String? labLogoUrl;
  final String registrationCertificateUrl;
  final String bankPassbookUrl;
  final String? emergencyContactNumber;
  final String? whatsappNumber;
  final String status;

  PathoLabModel({
    required this.labId,
    required this.labName,
    required this.mobileNumber,
    required this.emailAddress,
    this.gstNumber,
    required this.panNumber,
    required this.nablAccreditationNumber,
    required this.address,
    this.labLogoUrl,
    required this.registrationCertificateUrl,
    required this.bankPassbookUrl,
    this.emergencyContactNumber,
    this.whatsappNumber,
    required this.status,
  });

  factory PathoLabModel.fromJson(Map<String, dynamic> json) {
    return PathoLabModel(
      labId: json['lab_id'] ?? '',
      labName: json['lab_name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      emailAddress: json['email_address'] ?? '',
      gstNumber: json['gst_number'],
      panNumber: json['pan_number'] ?? '',
      nablAccreditationNumber: json['nabl_accreditation_number'] ?? '',
      address: json['address'] ?? '',
      labLogoUrl: json['lab_logo_url'],
      registrationCertificateUrl: json['registration_certificate_url'] ?? '',
      bankPassbookUrl: json['bank_passbook_url'] ?? '',
      emergencyContactNumber: json['emergency_contact_number'],
      whatsappNumber: json['whatsapp_number'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lab_id': labId,
      'lab_name': labName,
      'mobile_number': mobileNumber,
      'email_address': emailAddress,
      'gst_number': gstNumber,
      'pan_number': panNumber,
      'nabl_accreditation_number': nablAccreditationNumber,
      'address': address,
      'lab_logo_url': labLogoUrl,
      'registration_certificate_url': registrationCertificateUrl,
      'bank_passbook_url': bankPassbookUrl,
      'emergency_contact_number': emergencyContactNumber,
      'whatsapp_number': whatsappNumber,
      'status': status,
    };
  }
}
