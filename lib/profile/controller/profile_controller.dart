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
  getUserInfo() async {
    var response = await userRepo.getUserDetails();
    userInf.value = UserModel.fromJson(response[APIRESPONSE.SUCCESS]);
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    Map<String, dynamic> response = await userRepo.deleteAccount();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      SharedPreferences.getInstance().then((value) => value.clear());
      Get.offAll(() => LoginScreen());
    }
    return response;
  }

  Future<Map<String, dynamic>> logout() async {
    Map<String, dynamic> response = await userRepo.logout();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      SharedPreferences.getInstance().then((value) => value.clear());
      Get.offAll(() => LoginScreen());
    }
    return response;
  }

  @override
  void onReady() async {
    await getUserInfo();
    nameController.text = userInf.value?.user?.name ?? '';
    addressController.text = userInf.value?.user?.streetAddress ?? '';
    emailController.text = userInf.value?.user?.email ?? '';
    phoneController.text = userInf.value?.user?.mobile ?? '';
    passwordController.text = '';
    confirmPassController.text = '';

    super.onReady();
  }
}
