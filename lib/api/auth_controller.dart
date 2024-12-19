import 'dart:async';
import 'dart:developer';

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

  Future<Map<String, dynamic>> login(
      {required String password,
      required String mobileNumber,
      String? userType,
      required String fcmToken}) async {
    // Debug: Print input parameters
    print('Password: $password');
    print('Mobile Number: $mobileNumber');
    print('User Type: $userType');
    print('FCM Token: $fcmToken');

    // Call the login API
    Map<String, dynamic> response = await authRepo.login(
      password: password,
      mobileNumber: mobileNumber,
      userType: userType,
      fcmToken: fcmToken,
    );

    // Debug: Log the entire response
    log('API Response: $response');

    // Check for a valid SUCCESS response
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[APIRESPONSE.SUCCESS];

      // Debug: Log the result payload
      print('Result Payload: $result');

      if (result.containsKey('message') &&
          result['message'] == 'User not found') {
        print('Condition matched: User not found');
        String message = 'User not found'.tr;

        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoAlertDialog(
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: Get.back,
                child: Text('Ok'.tr),
              ),
            ],
          ),
        );
      } else if (result.containsKey('message') &&
          result['message'] == 'user_type does not matched') {
        print('Condition matched: user_type does not matched');
        String message = 'User Type does not matched, Try another number'.tr;

        showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoAlertDialog(
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: Get.back,
                child: Text('Ok'.tr),
              ),
            ],
          ),
        );
      } else {
        print('Login successful, proceeding to save user data.');
        authRepo.saveLoginUserData(user: UserModel.fromJson(result));
        Get.offAll(() => LocationPage());
      }
    }
    // Handle error responses (e.g., 403 status code)
    else if (response.containsKey('message') &&
        response['message'] == 'User not found') {
      print('Condition matched: User not found in error response');
      String message = 'User not found'.tr;

      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => CupertinoAlertDialog(
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: Get.back,
              child: Text('Ok'.tr),
            ),
          ],
        ),
      );
    } else {
      // Handle other error responses
      print('Error Response: ${response['message']}');
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => CupertinoAlertDialog(
          content: Text('${response['message']}'),
          actions: [
            CupertinoDialogAction(
              onPressed: Get.back,
              child: Text('Ok'.tr),
            ),
          ],
        ),
      );
    }
    return response;
  }

  // Future<Map<String, dynamic>> login({
  //   required String password,
  //   required String mobileNumber,
  //   int? userType,
  //   required String fcmToken,
  // }) async
  // {
  //   // Debug: Print input parameters
  //   print('Password: $password');
  //   print('Mobile Number: $mobileNumber');
  //   print('User Type: $userType');
  //   print('FCM Token: $fcmToken');
  //
  //   // Call the login API
  //   Map<String, dynamic> response = await authRepo.login(
  //     password: password,
  //     mobileNumber: mobileNumber,
  //     userType: userType,
  //     fcmToken: fcmToken,
  //   );
  //
  //   // Debug: Log the entire response
  //   log('API Response: $response');
  //
  //   // Check for a valid SUCCESS response
  //   if (response.containsKey(APIRESPONSE.SUCCESS)) {
  //     Map<String, dynamic> result = response[APIRESPONSE.SUCCESS];
  //
  //     // Debug: Log the result payload
  //     print('Result Payload: $result');
  //
  //     if (result.containsKey('message') &&
  //         result['message'] == 'User not found') {
  //       print('Condition matched: User not found');
  //       String message = 'User not found'.tr;
  //
  //       showCupertinoModalPopup(
  //         context: Get.context!,
  //         builder: (_) => CupertinoAlertDialog(
  //           content: Text(message),
  //           actions: [
  //             CupertinoDialogAction(
  //               onPressed: Get.back,
  //               child: Text('Ok'.tr),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else if (result.containsKey('message') &&
  //         result['message'] == 'user_type does not matched') {
  //       print('Condition matched: user_type does not matched');
  //       String message = 'User Type does not matched, Try another number'.tr;
  //
  //       showCupertinoModalPopup(
  //         context: Get.context!,
  //         builder: (_) => CupertinoAlertDialog(
  //           content: Text(message),
  //           actions: [
  //             CupertinoDialogAction(
  //               onPressed: Get.back,
  //               child: Text('Ok'.tr),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       print('Login successful, proceeding to save user data.');
  //       authRepo.saveLoginUserData(user: UserModel.fromJson(result));
  //       Get.offAll(() => LocationPage());
  //     }
  //   }
  //   // Handle error responses (e.g., 403 status code)
  //   else if (response.containsKey('message') &&
  //       response['message'] == 'User not found') {
  //     print('Condition matched: User not found in error response');
  //     String message = 'User not found'.tr;
  //
  //     showCupertinoModalPopup(
  //       context: Get.context!,
  //       builder: (_) => CupertinoAlertDialog(
  //         content: Text(message),
  //         actions: [
  //           CupertinoDialogAction(
  //             onPressed: Get.back,
  //             child: Text('Ok'.tr),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     // Handle other error responses
  //     print('Error Response: ${response['message']}');
  //     showCupertinoModalPopup(
  //       context: Get.context!,
  //       builder: (_) => CupertinoAlertDialog(
  //         content: Text('${response['message']}'),
  //         actions: [
  //           CupertinoDialogAction(
  //             onPressed: Get.back,
  //             child: Text('Ok'.tr),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return response;
  // }

  // Sign Up Api

  Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String address,
    required String addressLat,
    required String addressLong,
    required int vehicleType,
    // required int bankId,
    required String password,
    required String iban,
    // required String drivingLicence,
    // required String bankAccount,
    required String confirmPass,
  }) async {
    Map<String, dynamic> response = await authRepo.registerUser(
        fullName: fullName,
        email: email,
        mobileNumber: mobileNumber,
        password: password,
        confirmPass: confirmPass,
        // bankAccount: bankAccount,
        // bankId: bankId,
        vehicleType: vehicleType,
        address: address,
        addressLat: addressLat,
        addressLong: addressLong,
        iban: iban
        // drivingLicence: drivingLicence
    );

    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      // Successful Registration
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => CupertinoAlertDialog(
          content: Text('registered successfully'.tr),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Get.to(() => LoginScreen()),
              child: Text('Ok'.tr),
            )
          ],
        ),
      );
    } else {
      // Handle Validation Errors
      String errorMessage = _formatValidationErrors(response['errors']);
      showCupertinoModalPopup(
        context: Get.context!,
        builder: (_) => CupertinoAlertDialog(
          content: Text(errorMessage),
          actions: [
            CupertinoDialogAction(
              onPressed: Get.back,
              child:  Text('Ok'.tr),
            )
          ],
        ),
      );
    }
    return response;

    // Function to Format Validation Errors Based on Locale
  }

  String _formatValidationErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) {
      return 'An unexpected error occurred.'.tr;
    }

    // Determine Current Locale
    Locale currentLocale = Get.locale ?? const Locale('en');
    bool isArabic = currentLocale.languageCode == 'ar';

    // Error Translations
    Map<String, Map<String, String>> translations = {
      'email': {
        'validation.unique': isArabic
            ? 'هذا البريد الإلكتروني مسجل بالفعل.'
            : 'This email is already registered.',
      },
      'mobile': {
        'validation.unique': isArabic
            ? 'هذا الرقم مسجل بالفعل.'
            : 'This mobile number is already registered.',
      },
    };

    List<String> formattedErrors = [];
    errors.forEach((field, messages) {
      for (var messageKey in messages) {
        String translatedMessage =
            translations[field]?[messageKey] ?? '$field: $messageKey';
        formattedErrors.add(translatedMessage);
      }
    });

    return formattedErrors.join('\n');
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
        await Get.to(() => LocationPage());
      });
    } else {
      AppUtils.showDialog('${response['message']}', () {
        Get.back();
      });
    }

    return response;
  }
}
