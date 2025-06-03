import 'package:dio/dio.dart';
import 'package:dynamic_center/Screens/login/model/login_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/imports.dart';
import 'dart:developer' as dev;

class AuthController extends GetxController {
  final storage = const FlutterSecureStorage();

  final _token = ''.obs;
  final _errormsg = ''.obs;
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  String get errormsg => _errormsg.value;
  String get token => _token.value;
  bool get isAuthenticated => _token.isNotEmpty;

  void setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> login(LoginRequest login) async {
    try {
      setLoading(true);
      Get.dialog(const LoadingDialog(), barrierDismissible: false);

      final response = await ApiService.dio.post(
        '/login',
        data: json.encode(login.toJson()),
      );

      if (response.statusCode == 200) {
        if (response.data['status'] == true) {
          _token.value = response.data['data']['access_token'];
          await storage.write(key: 'token', value: _token.value);
          dev.log('Token: ${_token.value}');
          dev.log('Login successful: ${response.data}');

          Get.back(); // Close the loader dialog
          setLoading(false);

          Get.snackbar(
            "Success", "Login successful",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          Get.offNamed(Routes.LANDINGPAGE);
        } else {
          Get.back(); // Close the loader dialog
          setLoading(false);

          Get.snackbar(
            "Error",
            "Invalid email or password",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        Get.back(); // Close the loader dialog
        setLoading(false);

        Get.snackbar(
          "Error",
          "Unexpected error occurred. Please try again.",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } on DioException catch (error) {
      Get.back(); // Close the loader dialog
      setLoading(false);

      if (DioExceptionType.connectionTimeout == error.type ||
          DioExceptionType.receiveTimeout == error.type ||
          DioExceptionType.connectionError == error.type) {
        _errormsg.value = "No internet connection, try again";
      } else if (error.response?.data != null) {
        dev.log('Error response: ${error.response!.data}');
        _errormsg.value = error.response!.data['message'].toString();
      } else {
        _errormsg.value = "An unexpected error occurred.";
      }

      Get.snackbar(
        "Error",
        _errormsg.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> logout() async {
    _token.value = ''; // reset the token
    await storage.delete(key: 'token');
    update(); // notify listeners
  }

  // Check Authentication
  Future<void> checkAuthentication() async {
    final token = await storage.read(key: 'token');

    if (token != null) {
      _token.value = token; // Update the token
      update(); // notify listeners
    }
  }
}