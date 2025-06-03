class VacctsModel {
  final bool status;
  final String message;
  final List<VacctsData> data;

  VacctsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VacctsModel.fromJson(Map<String, dynamic> json) {
    return VacctsModel(
      status: json['status'],
      message: json['message'],
      data: List<VacctsData>.from(json['data'].map((x) => VacctsData.fromJson(x))),
    );
  }

  toJson() {
    return {
      'status': status,
      'message': message,
      'data': data
    };
  }

  @override
  String toString() {
    return 'VacctsModel(status: $status, message: $message, data: $data)';
  }
}

class VacctsData {
  final int id;
  final int userId;
  final String accountName;
  final String accountNumber;
  final String provider;
  final String reference;
  final String status;

  VacctsData({
    required this.id,
    required this.userId,
    required this.accountName,
    required this.accountNumber,
    required this.provider,
    required this.reference,
    required this.status,
  });

  factory VacctsData.fromJson(Map<String, dynamic> json) {
    return VacctsData(
      id: json['id'],
      userId: json['user_id'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      provider: json['provider'],
      reference: json['reference'],
      status: json['status'],
    );
  }

  toJson() {
    return {
      'id': id,
      'user_id': userId,
      'account_name': accountName,
      'account_number': accountNumber,
      'provider': provider,
      'reference': reference,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'VacctsData(id: $id, userId: $userId, accountName: $accountName, accountNumber: $accountNumber, provider: $provider, reference: $reference, status: $status)';
  }
}
