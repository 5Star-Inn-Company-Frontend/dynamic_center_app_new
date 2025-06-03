// class WalletModel {
//   final bool status;
//   final String message;
//   final List<WalletData> data;

//   WalletModel({
//     required this.status,
//     required this.message,
//     required this.data,
//   });

//   factory WalletModel.fromJson(Map<String, dynamic> json) {
//     return WalletModel(
//       status: json['status'],
//       message: json['message'],
//       data: (json['data'] as List).map((e) => WalletData.fromJson(e)).toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'status': status,
//       'message': message,
//       'data': data.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class WalletData {
//   final int id;
//   final int userId;
//   final String name;
//   final int balance;
//   final int status;

//   WalletData({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.balance,
//     required this.status,
//   });

//   factory WalletData.fromJson(Map<String, dynamic> json) {
//     return WalletData(
//       id: json['id'],
//       userId: json['user_id'],
//       name: json['name'],
//       balance: json['balance'],
//       status: json['status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'name': name,
//       'balance': balance,
//       'status': status,
//     };
//   }

//   @override
//   String toString() {
//     return 'WalletData(id: $id, userId: $userId, name: $name, balance: $balance, status: $status)';
//   }
// }



class WalletModel {
  final bool status;
  final String message;
  final List<WalletData> data;

  WalletModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((e) => WalletData.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'WalletModel(status: $status, message: $message, data: $data)';
  }
}

class WalletData {
  final int id;
  final int userId;
  final String name;
  final int balance;
  final int status;

  WalletData({
    required this.id,
    required this.userId,
    required this.name,
    required this.balance,
    required this.status,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      balance: json['balance'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'balance': balance,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'WalletData(id: $id, userId: $userId, name: $name, balance: $balance, status: $status)';
  }
}