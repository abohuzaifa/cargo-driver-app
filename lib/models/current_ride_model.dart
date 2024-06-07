class CurrentRideModel {
  List<Data>? data;

  CurrentRideModel({this.data});

  CurrentRideModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? requestId;
  String? amount;
  String? userId;
  String? isAccept;
  String? createdAt;
  String? updatedAt;
  Data? data;
  Request? request;
  User? user;

  Data(
      {this.id,
      this.requestId,
      this.amount,
      this.userId,
      this.isAccept,
      this.createdAt,
      this.updatedAt,
      this.data,
      this.request,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestId = json['request_id'];
    amount = json['amount'];
    userId = json['user_id'];
    isAccept = json['is_accept'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['request_id'] = requestId;
    data['amount'] = amount;
    data['user_id'] = userId;
    data['is_accept'] = isAccept;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (request != null) {
      data['request'] = request!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class CurrentRideData {
  Headers? headers;
  Original? original;

  CurrentRideData({
    this.headers,
    this.original,
  });

  CurrentRideData.fromJson(Map<String, dynamic> json) {
    headers =
        json['headers'] != null ? Headers.fromJson(json['headers']) : null;
    original =
        json['original'] != null ? Original.fromJson(json['original']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headers != null) {
      data['headers'] = headers!.toJson();
    }
    if (original != null) {
      data['original'] = original!.toJson();
    }

    return data;
  }
}

class Headers {
  Headers();

  Headers.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class Original {
  String? msg;

  Original({this.msg});

  Original.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    return data;
  }
}

class Request {
  int? id;
  String? userId;
  String? parcelLat;
  String? parcelLong;
  String? parcelAddress;
  String? receiverLat;
  String? receiverLong;
  String? receiverAddress;

  Request(
      {this.id,
      this.userId,
      this.parcelLat,
      this.parcelLong,
      this.parcelAddress,
      this.receiverLat,
      this.receiverLong,
      this.receiverAddress});

  Request.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    parcelLat = json['parcel_lat'];
    parcelLong = json['parcel_long'];
    parcelAddress = json['parcel_address'];
    receiverLat = json['receiver_lat'];
    receiverLong = json['receiver_long'];
    receiverAddress = json['receiver_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['parcel_lat'] = parcelLat;
    data['parcel_long'] = parcelLong;
    data['parcel_address'] = parcelAddress;
    data['receiver_lat'] = receiverLat;
    data['receiver_long'] = receiverLong;
    data['receiver_address'] = receiverAddress;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? latitude;
  String? longitude;
  String? streetAddress;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.latitude,
      this.longitude,
      this.streetAddress});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    streetAddress = json['street_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['street_address'] = streetAddress;
    return data;
  }
}
