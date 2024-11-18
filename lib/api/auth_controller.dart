import 'dart:async';

import 'package:cargo_driver_app/home/confirm_location_screen.dart';
import 'package:cargo_driver_app/util/apputils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../api/api_constants.dart';

import '../auth_screen/login_screen.dart';
import '../models/user_model.dart';
import './auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});
  int? forgotUserId;
  String? forgotUserPhoneNo;
  final bool _notification = true;
  final bool _acceptTerms = true;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  String? _userPhoneNo;
  String? _userCountryCode;
  String? get userPhoneNo => _userPhoneNo;
  String? get userCountryCode => _userCountryCode;

  UserModel? getLoginUserData() {
    return authRepo.getLoginUserData();
  }

  String? getFcmToken() {
    return authRepo.getFcmToken();
  }

  void updateLoginUserData({required UserModel user}) {
    authRepo.saveLoginUserData(user: user);
  }

  bool isLoginUser({required int userId}) {
    return true;
  }

  bool clearSharedData() {
    authRepo.clearSharedData();
    return true;
  }
  //Login Api


  Future<Map<String, dynamic>> login({
    required String password,
    required String mobileNumber,
    String? userType,
    required String fcmToken
  }) async {
    Map<String, dynamic> response = await authRepo.login(
        password: password,
        mobileNumber: mobileNumber,
        userType: userType, fcmToken:fcmToken
    );
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[APIRESPONSE.SUCCESS];

      // Save user data
      authRepo.saveLoginUserData(user: UserModel.fromJson(result));

      // Print the saved user data for debugging
      print('Saved User Data: ${result.toString()}');

      Get.offAll(() => const LocationPage());
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }

  //Sign Up Api
  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String address,
    required int vehicleType,
    required int bankId,
    required String password,
    required String drivingLicence,
    required String bankAccount,
    required String confirmPass,
  }) async {
    Map<String, dynamic> response = await authRepo.registerUser(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
        confirmPass: confirmPass,
        bankAccount: bankAccount,
        bankId: bankId,
        vehicleType: vehicleType,
        address: address,
        drivingLicence: drivingLicence);

    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      AppUtils.showDialog('User Created Successfully', () {
        Get.to(() => LoginScreen());
      });
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }

  Future<Map<String, dynamic>> updateFcmToken(
      {required String fcmToken}) async {
    debugPrint("updateFcmToken:->$fcmToken");
    Map<String, dynamic> response =
        await authRepo.updateFcmToken(fcmToken: fcmToken);
    authRepo.setSharedPreferenceFcmToken(fcmToken: fcmToken);
    return response;
  }

//
  bool isLogedIn() {
    return authRepo.isLoggedIn();
  }

//Logout
  Future<Map<String, dynamic>> logout() async {
    Map<String, dynamic> response = await authRepo.logout();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      authRepo.clearSharedData();
      Get.offAll(() => LoginScreen());
    }
    return response;
  }

  //Generate OTP
  Future<Map<String, dynamic>> generateOTP({
    String? smsText,
    String? cnic,
    int? islogin,
  }) async {
    Map<String, dynamic> response =
        await authRepo.genearateOtp(cnic: cnic, islogin: islogin);

    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      authRepo.saveLoginUserData(user: UserModel());
      Get.offAllNamed('/otp',
          arguments: {'mobileNum': '', 'loginKey': 0, 'cnic': cnic});
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }

  //resend
  Future<Map<String, dynamic>> resendOTP({
    String? smsText,
    String? cnic,
    int? islogin,
  }) async {
    Map<String, dynamic> response =
        await authRepo.genearateOtp(cnic: cnic, islogin: islogin);

    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      authRepo.saveLoginUserData(user: UserModel());
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }

  //
  Future<Map<String, dynamic>> resetPassword({
    String? password,
    String? conformPassword,
  }) async {
    Map<String, dynamic> response = await authRepo.resetPassword(
        password: password ?? '', confirmPassword: conformPassword ?? '');

    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      AppUtils.showDialog('$response', () {
        Get.back();
      });
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }

  //Verify OTP
  Future<Map<String, dynamic>> verifyOTP(
    String? code,
    int? islogin,
  ) async {
    Map<String, dynamic> response =
        await authRepo.verifyOTP(code: code, islogin: islogin);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      authRepo.saveLoginUserData(user: UserModel());
      Future.delayed(const Duration(seconds: 1), () async {
        await Get.to(() => const LocationPage());
      });
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }
}
