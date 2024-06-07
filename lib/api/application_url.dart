// ignore_for_file: non_constant_identifier_names, constant_identifier_names

class ApplicationUrl {
  // static const String _BASE_URL = 'https://onenetworkapp.com';
  // static const String _BASE_URL = 'http://10.10.5.101:9000';
  static const String _BASE_URL = 'http://delivershipment.com/api';
  // static const String _BASE_URL = 'https://115.186.178.138:8500';
  static const String _IMAGE_ULR = _BASE_URL;
  static String get IMAGE_ULR => _IMAGE_ULR;
  static const String _LOGIN_URL = '$_BASE_URL/login';
  static String get LOGIN_URL => _LOGIN_URL;
  static const String _VERIFYOTP_URL = '$_BASE_URL/verifyOTP';
  static String get VERIFYOTP_URL => _VERIFYOTP_URL;
  static const String _GENERATEOTP_URL = '$_BASE_URL/generateOTP';
  static String get GENERATEOTP_URL => _GENERATEOTP_URL;
  static const String _GETALLCATEGORIES_URL = '$_BASE_URL/getAllCategory';
  static String get GETALLCATEGORIES_URL => _GETALLCATEGORIES_URL;
  static const String _GETALLUSERTRIPS_URL = '$_BASE_URL/allTrips';
  static String get GETALLUSERTRIPS_URL => _GETALLUSERTRIPS_URL;
  static const String _GETBANNERS_URL = '$_BASE_URL/getBanners';
  static String get GETBANNERS_URL => _GETBANNERS_URL;
  static const String _RESETPASS_URL = '$_BASE_URL/reset';
  static String get RESETPASS_URL => _RESETPASS_URL;
  static const String _REGISTER_URL = '$_BASE_URL/createDriver';
  static String get REGISTER_URL => _REGISTER_URL;
  static const String _CONFIRMLOCATION_URL = '$_BASE_URL/setLocation';
  static String get CONFIRMLOCATION_URL => _CONFIRMLOCATION_URL;
  static const String _ADDDRIVERTRIP_URL = '$_BASE_URL/addTrip';
  static String get ADDDRIVERTRIP_URL => _ADDDRIVERTRIP_URL;
  static const String _LOGOUT_URL = '$_BASE_URL/logout';
  static String get LOGOUT_URL => _LOGOUT_URL;
  static const String _BANKLIST_URL = '$_BASE_URL/bankList';
  static String get BANKLIST_URL => _BANKLIST_URL;
  static const String _CREATERIDEREQUEST_URL = '$_BASE_URL/createRequest';
  static String get CREATERIDEREQUEST_URL => _CREATERIDEREQUEST_URL;
  static const String _GETWALLET_URL = '$_BASE_URL/getWalletSummary';
  static String get GETWALLET_URL => _GETWALLET_URL;
  static const String _UPDATEVEHICLEINFO_URL = '$_BASE_URL/updateVehicle';
  static String get UPDATEVEHICLEINFO_URL => _UPDATEVEHICLEINFO_URL;
  static const String _UPDATEUUSE_URL = '$_BASE_URL/updateUser';
  static String get UPDATEUSER_URL => _UPDATEUUSE_URL;
  static const String _GETUSER_URL = '$_BASE_URL/user';
  static String get GETUSER_URL => _GETUSER_URL;
  static const String _DLETETUSER_URL = '$_BASE_URL/user';
  static String get DLETETUSER_URL => _DLETETUSER_URL;
  static const String _GETCURRENTRIDES_URL = '$_BASE_URL/currentRidesList';
  static String get GETCURRENTRIDES_URL => _GETCURRENTRIDES_URL;
  static const String _ADDOFFER_URL = '$_BASE_URL/addOffer';
  static String get ADDOFFER_URL => _ADDOFFER_URL;
  static const String _GETTRANSACTION_URL =
      '$_BASE_URL/recentTransactionHistory/0';
  static String get GETTRANSACTION_URL => _GETTRANSACTION_URL;
  static const String _CREATEHISTORY_URL = '$_BASE_URL/createHistory';
  static String get CREATEHISTORY_URL => _CREATEHISTORY_URL;
}
//createHistory
//updateVehicle
//user
//deleteUser
//currentRidesList
///recentTransactionHistory