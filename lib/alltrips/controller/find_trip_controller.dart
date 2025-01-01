import 'dart:async';

import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:get/get.dart';

import '../../api/api_constants.dart';
import '../model/find_tripmodel.dart';

class FindTripController extends GetxController implements GetxService {
  final UserRepo userRepo;
  FindTripController({required this.userRepo});
  var allTrips = Rx<FindTripModel?>(null);
  Future<Map<String, dynamic>> getAllUserTrips({int? page}) async {
    var response = await userRepo.getAllUsersTrips(page: page);
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      return response;
    }
    return response;
  }

}
