import 'package:dio/dio.dart' as dio;
import '../../api/application_url.dart';
import 'api_constants.dart';
import 'api_structure.dart';

//testing comment
class UserRepo {
  UserRepo();
  Future<Map<String, dynamic>> registerUser({
    required String cnic,
    required String fullName,
    required String mobileNumber,
    String? fcmToken,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: '',
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: {
        "name": fullName,
        "PhoneNumber": mobileNumber,
        "CnicNumber": cnic,
        "fcm_token": fcmToken,
      },
    );

    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

//Confirm Locatiom
  Future<Map<String, dynamic>> confirmLocation({
    required String userId,
    required String address,
    required String lat,
    required String lang,
    required String city,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.CONFIRMLOCATION_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: {
        "user_id": userId,
        "street_address": address,
        "latitude": lat,
        "longitude": lang,
        "city": city,
      },
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

// DashBoard Data
  Future<Map<String, dynamic>> getBankList(
      {String? appVersion, deviceID}) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.BANKLIST_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );

    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

// Get Banners
  Future<Map<String, dynamic>> getBanners(
      {String? appVersion, deviceID}) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.GETBANNERS_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );

    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }

// GetTransactionsHistory
  Future<Map<String, dynamic>> getTransactionHistory() async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.GETTRANSACTION_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );

    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> getCurrentRequest(
      {String? appVersion, deviceID}) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.GETCURRENTRIDES_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );

    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> addDriverTrip({
    required String from,
    required String to,
    required String date,
    required String time,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.ADDDRIVERTRIP_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap({
        "from": from,
        "to": to,
        "date": date,
        "time": time,
      }),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> bidOnUserRequest({
    required String requestId,
    required String amount,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.ADDOFFER_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap({
        "request_id": requestId,
        "amount": amount,
      }),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

// GENERATE RIDE REQUEST
  Future<Map<String, dynamic>> createRideRequest({
    required String? fromCity,
    required String? toCity,
    required String? parcelLat,
    required String? parcelLong,
    required String? parcellAddress,
    required String? receiveLat,
    required String? receiverLong,
    required String? receiverAddress,
    required String? receiverMob,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.CREATERIDEREQUEST_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap({
        "from_date": fromCity,
        "to_date": toCity,
        "parcel_lat": parcelLat,
        "parcel_long": parcelLong,
        "parcel_address": parcellAddress,
        "receiver_lat": 123,
        "receiver_long": 123,
        "receiver_address": "receive-address",
        "receiver_mobile": receiverMob,
      }),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> getUserDetails() async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.GETUSER_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> getAllUsersTrips({int? page}) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: '${ApplicationUrl.GETALLUSERTRIPS_URL}?page=${page ?? 1}',
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> getWalletSummary() async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.GETWALLET_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> updateVehicleInfo({
    required String plateNumber,
    required String vehicleTyep,
    required String drivingLicence,
  }) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.UPDATEVEHICLEINFO_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap(
        {
          "number_plate": plateNumber, //"AGS 9734",
          "vehicle_type": 1, //    "2",
          "driving_license": drivingLicence, // "iien87731739saeu",
        },
      ),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> updateUserInfo({
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
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.UPDATEUSER_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap(
        {
          "name": name,
          "mobile": mobile,
          "email": email,
          "street_address": streetAddress,
          "city": city,
          "state": state,
          "postal_code": postalCode,
          "latitude": lat,
          "longitude": long,
          'image': ''
        },
      ),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> deleteAccount() async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.DLETETUSER_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );

    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> logout() async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.LOGOUT_URL,
      apiRequestMethod: APIREQUESTMETHOD.GET,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> createRideHistory(
      {required String requestId,
      required String lat,
      required String long,
      String? address,
      required String isStart,
      required String isEnd}) async {
    APISTRUCTURE apiObject = APISTRUCTURE(
      apiUrl: ApplicationUrl.CREATEHISTORY_URL,
      apiRequestMethod: APIREQUESTMETHOD.POST,
      isWantSuccessMessage: true,
      body: dio.FormData.fromMap(
        {
          "request_id": requestId,
          "lat": lat,
          "long": long,
          "address": address,
          "is_start": isStart,
          "is_end": isEnd,
        },
      ),
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: false);
  }
}
