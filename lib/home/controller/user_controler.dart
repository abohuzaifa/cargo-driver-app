import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:cargo_driver_app/auth_screen/login_screen.dart';
import 'package:cargo_driver_app/models/current_ride_model.dart';
import 'package:cargo_driver_app/models/wallet_model.dart';
import 'package:cargo_driver_app/util/apputils.dart';
import 'package:get/get.dart';

class UserContorller extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserContorller({required this.userRepo});

  var walletData = Rx<WalletModel?>(null);
  var currenTRideModel = Rx<CurrentRideModel?>(null);

  addDriverTrip({
    required String from,
    required String to,
    required String date,
    required String time,
    required String description,
    required String price,
  }) async {
    try {
      var response = await userRepo.addDriverTrip(
          from: from,
          to: to,
          date: date,
          time: time,
          description: description,
          price: price);

      if (response.containsKey(APIRESPONSE.SUCCESS)) {
        AppUtils.showDialog('Successfully created'.tr, () {
          Get.back();
          Get.back();
        });
      } else if (response.containsKey('errors')) {
        // Parse and display errors
        Map<String, dynamic> errors = response['errors'];
        String errorMessages = errors.entries
            .map((entry) =>
                "${entry.key.capitalizeFirst}: ${entry.value.join(', ')}")
            .join('\n');

        AppUtils.showDialog('Validation Errors:\n$errorMessages', () {
          Get.back();
        });
      } else {
        AppUtils.showDialog('Something went wrong, please try again', () {});
      }
    } catch (e) {
      // Handle unexpected exceptions
      AppUtils.showDialog('An unexpected error occurred: $e', () {});
    }
  }

  //
  Future<void> getWalletSummary() async {
    var response = await userRepo.getWalletSummary();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      walletData.value = WalletModel.fromJson(response[APIRESPONSE.SUCCESS]);
    } else {
      AppUtils.showDialog('Something went wrong please, Try again', () {
        Get.back();
        Get.back();
      });
    }
  }

  Future<void> getCurrentRequests() async {
    var response = await userRepo.getCurrentRequest();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      currenTRideModel.value =
          CurrentRideModel.fromJson(response[APIRESPONSE.SUCCESS]);
    } else {
      AppUtils.showDialog('Something went wrong please, Try again', () {
        Get.back();
        Get.back();
      });
    }
  }

  Future<void> updateVehicleInfo({
    required String plateNumber,
    required String vehicleTyep,
    required String drivingLicence,
  }) async {
    var response = await userRepo.updateVehicleInfo(
        plateNumber: plateNumber,
        vehicleTyep: vehicleTyep,
        drivingLicence: drivingLicence);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      AppUtils.showDialog('Data Updated', () {
        Get.back();
      });
    } else {
      AppUtils.showDialog(response['message'], () {
        Get.back();
      });
    }
  }

  Future<void> updateUserInfo({
    required String mobile,
    required String name,
    required String email,
    required String streetAddress,
    required String city,
    required String state,
    required String postalCode,
    required String lat,
    required String long,
  }) async {
    var response = await userRepo.updateUserInfo(
        mobile: mobile,
        name: name,
        email: email,
        streetAddress: streetAddress,
        city: city,
        state: state,
        postalCode: postalCode,
        lat: lat,
        long: long);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      AppUtils.showDialog('Data Updated', () {
        Get.offAll(() => LoginScreen());
      });
    } else {
      AppUtils.showDialog(response['message'], () {
        Get.back();
      });
    }
  }

  @override
  void onReady() async {
    Future.wait([getWalletSummary(), getCurrentRequests()]);
    super.onReady();
  }
}
