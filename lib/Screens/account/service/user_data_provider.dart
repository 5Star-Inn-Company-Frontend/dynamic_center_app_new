import 'package:dio/dio.dart';
import 'package:dynamic_center/core/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as fss;
import 'package:get/get.dart';
import '../models/vaccts_model.dart';
import '../models/profile_model.dart';
import '../models/wallet_model.dart';

class UserDataProvider extends GetxController {
  var userData = Rxn<ProfileModel>();
  var userVacctData = Rxn<VacctsModel>();
  var walletData = Rxn<WalletModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Set loading state
  void setLoading(bool value) => isLoading.value = value;

  // Set user data
  void setUserData(ProfileModel data) => userData.value = data;

  // Set user account data
  void setUserAccountData(VacctsModel data) => userVacctData.value = data;

  // Set wallet data
  void setWalletData(WalletModel data) => walletData.value = data;

  // method for loading user data
  Future<ProfileModel?> loadUserData() async {
    final token = await const fss.FlutterSecureStorage().read(key: 'token');

    if (token == null) {
      errorMessage.value = 'Error: Token is missing';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return null;
    }

    try {
      setLoading(true);

      final response = await ApiService.dio.get(
        '/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = ProfileModel.fromJson(response.data['data']);
        setUserData(userData);
        // dev.log('User data loaded successfully: $userData');
        return userData;
      } 
      else {
        errorMessage.value = 'Unexpected status code: ${response.statusCode}';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      }
    } on DioException catch (e) {
      handleDioException(e);
    } finally {
      setLoading(false);
    }

    return null;
  }

  // method for loading vaccts data
  Future<VacctsModel?> loadVacctsData() async {
    final token = await const fss.FlutterSecureStorage().read(key: 'token');

    if (token == null) {
      errorMessage.value = 'Error: Token is missing';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return null;
    }

    try {
      setLoading(true);

      final response = await ApiService.dio.get(
        '/vaccts',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final vacctsData = VacctsModel.fromJson(response.data);
        setUserAccountData(vacctsData);
        // dev.log('Vaccts data loaded successfully: $vacctsData');
        return vacctsData;
      } else {
        errorMessage.value = 'Unexpected status code: ${response.statusCode}';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      }
    } on DioException catch (e) {
      handleDioException(e);
    } finally {
      setLoading(false);
    }

    return null;
  }

  // method for loading wallet data
  Future<WalletModel?> loadWallet(BuildContext context) async {
    final token = await const fss.FlutterSecureStorage().read(key: 'token');

    if (token == null) {
      errorMessage.value = 'Error: Token is missing';
      Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      return null;
    }

    try {
      setLoading(true);

      final response = await ApiService.dio.get(
        '/wallets',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final walletData = WalletModel.fromJson(response.data);
        setWalletData(walletData);
        // dev.log('Wallet data loaded successfully: $walletData');
        return walletData;
      } else {
        errorMessage.value = 'Unexpected status code: ${response.statusCode}';
        Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
      }
    } on DioException catch (e) {
      handleDioException(e);
    } finally {
      setLoading(false);
    }

    return null;
  }

  void handleDioException(DioException e) {
    errorMessage.value = e.message ?? 'An error occurred';
    Get.snackbar('Error', errorMessage.value, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);

    if ([
      DioExceptionType.connectionError,
      DioExceptionType.connectionTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.sendTimeout,
    ].contains(e.type)) {
      Get.snackbar('Error', 'Poor Internet connection, try again.', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    } else if (DioExceptionType.badResponse == e.type) {
      Get.snackbar('Error', 'Unable to make request, try again.', backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.TOP);
    }
  }
}