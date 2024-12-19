import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:cargo_driver_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth_screen/login_screen.dart';

class ProfileController extends GetxController implements GetxService {
  final UserRepo userRepo;

  ProfileController({required this.userRepo});

  final nameController = TextEditingController(),
      addressController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController(),
      passwordController = TextEditingController(),
      confirmPassController = TextEditingController();
  var userInf = Rx<UserModel?>(null);

  // Fetch user information
  getUserInfo() async {
    try {
      var response = await userRepo.getUserDetails();
      if (response.containsKey(APIRESPONSE.SUCCESS)) {
        userInf.value = UserModel.fromJson(response[APIRESPONSE.SUCCESS]);
      } else {
        throw Exception("Failed to fetch user details");
      }
    } catch (e) {
      print("Error in getUserInfo: $e");
    }
  }

  // Delete account
  Future<Map<String, dynamic>> deleteAccount() async {
    Map<String, dynamic> response = await userRepo.deleteAccount();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      SharedPreferences.getInstance().then((value) => value.clear());
      Get.delete<ProfileController>(); // Remove this controller from memory
      Get.offAll(() => LoginScreen());
    }
    return response;
  }

  // Logout user
  Future<Map<String, dynamic>> logout() async {
    Map<String, dynamic> response = await userRepo.logout();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      SharedPreferences.getInstance().then((value) => value.clear());
      Get.delete<ProfileController>(); // Remove this controller from memory
      Get.offAll(() => LoginScreen());
    }
    return response;
  }

  @override
  void onReady() async {
    // Only fetch user info if controller is active
    try {
      await getUserInfo();
      nameController.text = userInf.value?.user?.name ?? '';
      addressController.text = userInf.value?.user?.streetAddress ?? '';
      emailController.text = userInf.value?.user?.email ?? '';
      phoneController.text = userInf.value?.user?.mobile ?? '';
      passwordController.text = '';
      confirmPassController.text = '';
    } catch (e) {
      print("Error in onReady: $e");
    }
    super.onReady();
  }

  @override
  void onClose() {
    // Dispose of text controllers when the controller is removed
    nameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    super.onClose();
  }
}
