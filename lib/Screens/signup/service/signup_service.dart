
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/imports.dart';

class SignUpService extends GetxController {
  final logic = Get.find<SignUpLogic>();
  final state = Get.find<SignUpLogic>().state;

  String? _errorMsg;

  void setLoading(bool value) => state.isLoading.value = value;

  Future<SignupModel> signup(SignupModel user, BuildContext context) async {
    try {
      setLoading(true);
      if (state.isLoading.value == true) {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return const LoadingDialog();
          },
        );
      }

      final response = await ApiService.dio.post(
        '/register',
        data: json.encode(
          {
            'firstname': logic.firstNameController.text.trim(),
            'lastname': logic.lastNameController.text.trim(),
            'email': logic.emailController.text.trim(),
            'password': logic.passwordController.text,
            'phone': logic.phoneController.text.trim(),
            'address': 'null',
            'gender': 'null',
            'dob': 'null',
          }
        )
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading(false);
        if (state.isLoading.value == false) {
          Get.back();
          // Get.toNamed(Routes.VERIFYEMAIL);

          showCupertinoDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Image.asset(
                      //   "assets/images/insurance.png",
                      //   width: 200.h
                      // ),
                      Gap(8.h),
                      Text(
                        "Welcome! ${logic.firstNameController.text.trim().toUpperCase()}",
                        style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w700),
                      ),
                      Gap(8.h),
                      const Text(
                        "You have successfully Registered!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                      ),
                      Gap(8.h),
                      LoadButton(
                        label: "Continue to Login",
                        function: () async {
                          Get.back();
                          Get.toNamed(Routes.LOGINVIEW);
                          // await widget.toggleView!(true);
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }

        if (response.data['status'] == true) {
          dev.log('sign up successful');
          dev.log(response.data['message']);
        } else if (response.data['status'] == false) {
          dev.log(response.data['message']);
          _showErrorMessage(response.data['message'], context);

        }
      }
    } on DioException catch (error) {
      if (DioExceptionType.connectionTimeout == error.type || DioExceptionType.receiveTimeout == error.type || DioExceptionType.connectionError == error.type) {
        setLoading(false);
        if (state.isLoading.value == false) {
          Get.back();
        }
        
        _errorMsg = "No internet connection, try again";
        _showErrorMessage(_errorMsg!, context);
      }
      if (error.response != null) {
        dev.log("Error response data: ${error.response!.data}");
        dev.log("Error response status: ${error.response!.statusCode}");
        setLoading(false);

        if (state.isLoading.value == false) {
          Get.back();
        }

        String errorMessage = "Unable to complete registration";
        if (error.response!.data is Map && error.response!.data.containsKey('error')) {
          errorMessage = error.response!.data['error'];
        }
        dev.log("Error response data: ${error.response!.data['error']}");
        _showErrorMessage(errorMessage, context);
      }
    }
    return SignupModel(
      firstName: "",
      lastName: "",
      phone: "",
      email: "",
      password: "",
      address: "",
      gender: "",
      dob: "",
    );
  }

  void _showErrorMessage(String message, BuildContext context) {
    Flushbar(
      message: message,
      flushbarStyle: FlushbarStyle.GROUNDED,
      isDismissible: true,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
    ).show(context);
  }
}