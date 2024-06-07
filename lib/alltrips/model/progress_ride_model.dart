class ProgressRideModel {
  String? status;
  UserLoc? userLoc;
  ProgressRideModel({this.status, this.userLoc});
  factory ProgressRideModel.fromjson(Map<String, dynamic> json) {
    return ProgressRideModel(
        status: 'ride_status',
        userLoc: json['user_location'] != null
            ? UserLoc.fromJson(json['user_location'])
            : null);
  }
}

class UserLoc {
  double? latitude;
  double? longitude;
  UserLoc({this.latitude, this.longitude});

  factory UserLoc.fromJson(Map<String, dynamic> json) {
    return UserLoc(latitude: json['latitude'], longitude: json['longitude']);
  }
}
