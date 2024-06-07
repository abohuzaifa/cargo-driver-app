import 'package:cargo_driver_app/alltrips/controller/find_trip_controller.dart';
import 'package:cargo_driver_app/api/auth_controller.dart';
import 'package:cargo_driver_app/api/auth_repo.dart';
import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:cargo_driver_app/home/controller/location_controller.dart';
import 'package:cargo_driver_app/home/controller/ridetrcaking_controller.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';
import 'package:cargo_driver_app/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Binding extends Bindings {
  @override
  void dependencies() async {
    Get.put(AuthController(
      authRepo: AuthRepo(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
    ));
    Get.lazyPut(() => LocationController(userRepo: UserRepo()));
    Get.lazyPut(() => UserContorller(userRepo: UserRepo()));
    Get.lazyPut(() => FindTripController(userRepo: UserRepo()));
    Get.lazyPut(() => ProfileController(userRepo: UserRepo()));
    Get.lazyPut(() => RideTrackingController(userRepo: UserRepo()));
  }
}
