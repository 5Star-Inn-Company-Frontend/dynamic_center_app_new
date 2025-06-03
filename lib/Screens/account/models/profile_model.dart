class ProfileModel {
  final int id;
  final String firstname;
  final String lastname;
  final String address;
  final String phone;
  final String gender;
  final String dob;
  final String email;
  final int? refererId;
  final int refererBonusPaid;
  final String? emailVerifiedAt;
  final String package;
  final String? bvn;
  final String? bankCode;
  final String? accountName;
  final String? accountNumber;
  final String createdAt;
  final String updatedAt;

  // final String? accountDetails;

  ProfileModel( {
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.email,
    this.refererId,
    required this.refererBonusPaid,
    this.emailVerifiedAt,
    required this.package,
    this.bvn,
    this.bankCode,
    this.accountName,
    this.accountNumber,
    required this.createdAt,
    required this.updatedAt,

    // this.accountDetails,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      address: json['address'],
      phone: json['phone'],
      gender: json['gender'],
      dob: json['dob'],
      email: json['email'],
      refererId: json['referer_id'],
      refererBonusPaid: json['referer_bonus_paid'],
      emailVerifiedAt: json['email_verified_at'],
      package: json['package'],
      bvn: json['bvn'],
      bankCode: json['bank_code'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      // accountDetails: json['accountDetails']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'address': address,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'email': email,
      'referer_id': refererId,
      'referer_bonus_paid': refererBonusPaid,
      'email_verified_at': emailVerifiedAt,
      'package': package,
      'bvn': bvn,
      'bank_code': bankCode,
      'account_name': accountName,
      'account_number': accountNumber,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  String toString() {
    return '''ProfileModel(
    id: $id, 
    firstname: $firstname, 
    lastname: $lastname, 
    address: $address, 
    phone: $phone, 
    'gender': $gender,
    'dob': $dob,
    'email': $email,
    'referer_id': $refererId,
    'referer_bonus_paid': $refererBonusPaid,
    'email_verified_at': $emailVerifiedAt,
    'package': $package,
    'bvn': $bvn,
    'bank_code': $bankCode,
    'account_name': $accountName,
    'account_number': $accountNumber,
    'created_at': $createdAt,
    'updated_at': $updatedAt,
    )''';
  }

}

