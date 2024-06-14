class MDGetRequestData {
  RequestData? requestData;

  MDGetRequestData({this.requestData});

  MDGetRequestData.fromJson(Map<String, dynamic> json) {
    requestData = json['requestData'] != null
        ? new RequestData.fromJson(json['requestData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requestData != null) {
      data['requestData'] = this.requestData!.toJson();
    }
    return data;
  }
}

class RequestData {
  int? id;
  String? userId;
  String? fromDate;
  String? toDate;
  String? images;
  String? parcelLat;
  String? parcelLong;
  String? parcelAddress;
  String? receiverLat;
  String? receiverLong;
  String? receiverAddress;
  String? receiverMobile;
  String? status;
  String? paymentStatus;
  String? amount;
  Null? invoiceId;
  String? offerId;
  Null? channelName;
  String? categoryId;
  String? createdAt;
  String? updatedAt;
  User? user;

  RequestData(
      {this.id,
        this.userId,
        this.fromDate,
        this.toDate,
        this.images,
        this.parcelLat,
        this.parcelLong,
        this.parcelAddress,
        this.receiverLat,
        this.receiverLong,
        this.receiverAddress,
        this.receiverMobile,
        this.status,
        this.paymentStatus,
        this.amount,
        this.invoiceId,
        this.offerId,
        this.channelName,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.user});

  RequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fromDate = json['from_date'];
    toDate = json['to_date'];
    images = json['images'];
    parcelLat = json['parcel_lat'];
    parcelLong = json['parcel_long'];
    parcelAddress = json['parcel_address'];
    receiverLat = json['receiver_lat'];
    receiverLong = json['receiver_long'];
    receiverAddress = json['receiver_address'];
    receiverMobile = json['receiver_mobile'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    amount = json['amount'];
    invoiceId = json['invoice_id'];
    offerId = json['offer_id'];
    channelName = json['channel_name'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['from_date'] = this.fromDate;
    data['to_date'] = this.toDate;
    data['images'] = this.images;
    data['parcel_lat'] = this.parcelLat;
    data['parcel_long'] = this.parcelLong;
    data['parcel_address'] = this.parcelAddress;
    data['receiver_lat'] = this.receiverLat;
    data['receiver_long'] = this.receiverLong;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_mobile'] = this.receiverMobile;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['amount'] = this.amount;
    data['invoice_id'] = this.invoiceId;
    data['offer_id'] = this.offerId;
    data['channel_name'] = this.channelName;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}