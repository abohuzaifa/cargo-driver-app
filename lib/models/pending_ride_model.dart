// ignore_for_file: unnecessary_getters_setters

class PendingRideRequestModel {
  Data? _data;

  PendingRideRequestModel({Data? data}) {
    if (data != null) {
      _data = data;
    }
  }

  Data? get data => _data;
  set data(Data? data) => _data = data;

  PendingRideRequestModel.fromJson(Map<String, dynamic> json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (_data != null) {
      data['data'] = _data!.toJson();
    }
    return data;
  }
}

class Data {
  int? _currentPage;
  List<Data>? _data;
  String? _firstPageUrl;
  int? _from;
  int? _lastPage;
  String? _lastPageUrl;
  List<Links>? _links;
  String? _nextPageUrl;
  String? _path;
  int? _perPage;
  String? _prevPageUrl;
  int? _to;
  int? _total;

  Data(
      {int? currentPage,
      List<Data>? data,
      String? firstPageUrl,
      int? from,
      int? lastPage,
      String? lastPageUrl,
      List<Links>? links,
      String? nextPageUrl,
      String? path,
      int? perPage,
      String? prevPageUrl,
      int? to,
      int? total}) {
    if (currentPage != null) {
      _currentPage = currentPage;
    }
    if (data != null) {
      _data = data;
    }
    if (firstPageUrl != null) {
      _firstPageUrl = firstPageUrl;
    }
    if (from != null) {
      _from = from;
    }
    if (lastPage != null) {
      _lastPage = lastPage;
    }
    if (lastPageUrl != null) {
      _lastPageUrl = lastPageUrl;
    }
    if (links != null) {
      _links = links;
    }
    if (nextPageUrl != null) {
      _nextPageUrl = nextPageUrl;
    }
    if (path != null) {
      _path = path;
    }
    if (perPage != null) {
      _perPage = perPage;
    }
    if (prevPageUrl != null) {
      _prevPageUrl = prevPageUrl;
    }
    if (to != null) {
      _to = to;
    }
    if (total != null) {
      _total = total;
    }
  }

  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  String? get firstPageUrl => _firstPageUrl;
  set firstPageUrl(String? firstPageUrl) => _firstPageUrl = firstPageUrl;
  int? get from => _from;
  set from(int? from) => _from = from;
  int? get lastPage => _lastPage;
  set lastPage(int? lastPage) => _lastPage = lastPage;
  String? get lastPageUrl => _lastPageUrl;
  set lastPageUrl(String? lastPageUrl) => _lastPageUrl = lastPageUrl;
  List<Links>? get links => _links;
  set links(List<Links>? links) => _links = links;
  String? get nextPageUrl => _nextPageUrl;
  set nextPageUrl(String? nextPageUrl) => _nextPageUrl = nextPageUrl;
  String? get path => _path;
  set path(String? path) => _path = path;
  int? get perPage => _perPage;
  set perPage(int? perPage) => _perPage = perPage;
  String? get prevPageUrl => _prevPageUrl;
  set prevPageUrl(String? prevPageUrl) => _prevPageUrl = prevPageUrl;
  int? get to => _to;
  set to(int? to) => _to = to;
  int? get total => _total;
  set total(int? total) => _total = total;

  Data.fromJson(Map<String, dynamic> json) {
    _currentPage = json['current_page'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(Data.fromJson(v));
      });
    }
    _firstPageUrl = json['first_page_url'];
    _from = json['from'];
    _lastPage = json['last_page'];
    _lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      _links = <Links>[];
      json['links'].forEach((v) {
        _links!.add(Links.fromJson(v));
      });
    }
    _nextPageUrl = json['next_page_url'];
    _path = json['path'];
    _perPage = json['per_page'];
    _prevPageUrl = json['prev_page_url'];
    _to = json['to'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = _currentPage;
    if (_data != null) {
      data['data'] = _data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = _firstPageUrl;
    data['from'] = _from;
    data['last_page'] = _lastPage;
    data['last_page_url'] = _lastPageUrl;
    if (_links != null) {
      data['links'] = _links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = _nextPageUrl;
    data['path'] = _path;
    data['per_page'] = _perPage;
    data['prev_page_url'] = _prevPageUrl;
    data['to'] = _to;
    data['total'] = _total;
    return data;
  }
}

class RideData {
  int? _id;
  String? _userId;
  String? _fromDate;
  String? _toDate;
  String? _images;
  String? _parcelLat;
  String? _parcelLong;
  String? _parcelAddress;
  String? _receiverLat;
  String? _receiverLong;
  String? _receiverAddress;
  String? _receiverMobile;
  String? _status;
  String? _paymentStatus;
  String? _amount;
  String? _invoiceId;
  String? _offerId;
  String? _channelName;
  String? _createdAt;
  String? _updatedAt;
  User? _user;

  RideData(
      {int? id,
      String? userId,
      String? fromDate,
      String? toDate,
      String? images,
      String? parcelLat,
      String? parcelLong,
      String? parcelAddress,
      String? receiverLat,
      String? receiverLong,
      String? receiverAddress,
      String? receiverMobile,
      String? status,
      String? paymentStatus,
      String? amount,
      String? invoiceId,
      String? offerId,
      String? channelName,
      String? createdAt,
      String? updatedAt,
      User? user}) {
    if (id != null) {
      _id = id;
    }
    if (userId != null) {
      _userId = userId;
    }
    if (fromDate != null) {
      _fromDate = fromDate;
    }
    if (toDate != null) {
      _toDate = toDate;
    }
    if (images != null) {
      _images = images;
    }
    if (parcelLat != null) {
      _parcelLat = parcelLat;
    }
    if (parcelLong != null) {
      _parcelLong = parcelLong;
    }
    if (parcelAddress != null) {
      _parcelAddress = parcelAddress;
    }
    if (receiverLat != null) {
      _receiverLat = receiverLat;
    }
    if (receiverLong != null) {
      _receiverLong = receiverLong;
    }
    if (receiverAddress != null) {
      _receiverAddress = receiverAddress;
    }
    if (receiverMobile != null) {
      _receiverMobile = receiverMobile;
    }
    if (status != null) {
      _status = status;
    }
    if (paymentStatus != null) {
      _paymentStatus = paymentStatus;
    }
    if (amount != null) {
      _amount = amount;
    }
    if (invoiceId != null) {
      _invoiceId = invoiceId;
    }
    if (offerId != null) {
      _offerId = offerId;
    }
    if (channelName != null) {
      _channelName = channelName;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (user != null) {
      _user = user;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get fromDate => _fromDate;
  set fromDate(String? fromDate) => _fromDate = fromDate;
  String? get toDate => _toDate;
  set toDate(String? toDate) => _toDate = toDate;
  String? get images => _images;
  set images(String? images) => _images = images;
  String? get parcelLat => _parcelLat;
  set parcelLat(String? parcelLat) => _parcelLat = parcelLat;
  String? get parcelLong => _parcelLong;
  set parcelLong(String? parcelLong) => _parcelLong = parcelLong;
  String? get parcelAddress => _parcelAddress;
  set parcelAddress(String? parcelAddress) => _parcelAddress = parcelAddress;
  String? get receiverLat => _receiverLat;
  set receiverLat(String? receiverLat) => _receiverLat = receiverLat;
  String? get receiverLong => _receiverLong;
  set receiverLong(String? receiverLong) => _receiverLong = receiverLong;
  String? get receiverAddress => _receiverAddress;
  set receiverAddress(String? receiverAddress) =>
      _receiverAddress = receiverAddress;
  String? get receiverMobile => _receiverMobile;
  set receiverMobile(String? receiverMobile) =>
      _receiverMobile = receiverMobile;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get paymentStatus => _paymentStatus;
  set paymentStatus(String? paymentStatus) => _paymentStatus = paymentStatus;
  String? get amount => _amount;
  set amount(String? amount) => _amount = amount;
  String? get invoiceId => _invoiceId;
  set invoiceId(String? invoiceId) => _invoiceId = invoiceId;
  String? get offerId => _offerId;
  set offerId(String? offerId) => _offerId = offerId;
  String? get channelName => _channelName;
  set channelName(String? channelName) => _channelName = channelName;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  User? get user => _user;
  set user(User? user) => _user = user;

  RideData.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _fromDate = json['from_date'];
    _toDate = json['to_date'];
    _images = json['images'];
    _parcelLat = json['parcel_lat'];
    _parcelLong = json['parcel_long'];
    _parcelAddress = json['parcel_address'];
    _receiverLat = json['receiver_lat'];
    _receiverLong = json['receiver_long'];
    _receiverAddress = json['receiver_address'];
    _receiverMobile = json['receiver_mobile'];
    _status = json['status'];
    _paymentStatus = json['payment_status'];
    _amount = json['amount'];
    _invoiceId = json['invoice_id'];
    _offerId = json['offer_id'];
    _channelName = json['channel_name'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['from_date'] = _fromDate;
    data['to_date'] = _toDate;
    data['images'] = _images;
    data['parcel_lat'] = _parcelLat;
    data['parcel_long'] = _parcelLong;
    data['parcel_address'] = _parcelAddress;
    data['receiver_lat'] = _receiverLat;
    data['receiver_long'] = _receiverLong;
    data['receiver_address'] = _receiverAddress;
    data['receiver_mobile'] = _receiverMobile;
    data['status'] = _status;
    data['payment_status'] = _paymentStatus;
    data['amount'] = _amount;
    data['invoice_id'] = _invoiceId;
    data['offer_id'] = _offerId;
    data['channel_name'] = _channelName;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    if (_user != null) {
      data['user'] = _user!.toJson();
    }
    return data;
  }
}

class User {
  int? _id;
  String? _name;
  String? _nameAr;
  String? _email;
  String? _image;
  String? _emailVerifiedAt;
  String? _mobile;
  String? _otp;
  String? _status;
  String? _userType;
  String? _streetAddress;
  String? _city;
  String? _state;
  String? _postalCode;
  String? _country;
  String? _latitude;
  String? _longitude;
  String? _twitter;
  String? _facebook;
  String? _instagram;
  String? _linkedin;
  String? _categoryId;
  String? _drivingLicense;
  String? _numberPlate;
  String? _bankId;
  String? _bankAccount;
  String? _isRead;
  String? _createdAt;
  String? _updatedAt;

  User(
      {int? id,
      String? name,
      String? nameAr,
      String? email,
      String? image,
      String? emailVerifiedAt,
      String? mobile,
      String? otp,
      String? status,
      String? userType,
      String? streetAddress,
      String? city,
      String? state,
      String? postalCode,
      String? country,
      String? latitude,
      String? longitude,
      String? twitter,
      String? facebook,
      String? instagram,
      String? linkedin,
      String? categoryId,
      String? drivingLicense,
      String? numberPlate,
      String? bankId,
      String? bankAccount,
      String? isRead,
      String? createdAt,
      String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (nameAr != null) {
      _nameAr = nameAr;
    }
    if (email != null) {
      _email = email;
    }
    if (image != null) {
      _image = image;
    }
    if (emailVerifiedAt != null) {
      _emailVerifiedAt = emailVerifiedAt;
    }
    if (mobile != null) {
      _mobile = mobile;
    }
    if (otp != null) {
      _otp = otp;
    }
    if (status != null) {
      _status = status;
    }
    if (userType != null) {
      _userType = userType;
    }
    if (streetAddress != null) {
      _streetAddress = streetAddress;
    }
    if (city != null) {
      _city = city;
    }
    if (state != null) {
      _state = state;
    }
    if (postalCode != null) {
      _postalCode = postalCode;
    }
    if (country != null) {
      _country = country;
    }
    if (latitude != null) {
      _latitude = latitude;
    }
    if (longitude != null) {
      _longitude = longitude;
    }
    if (twitter != null) {
      _twitter = twitter;
    }
    if (facebook != null) {
      _facebook = facebook;
    }
    if (instagram != null) {
      _instagram = instagram;
    }
    if (linkedin != null) {
      _linkedin = linkedin;
    }
    if (categoryId != null) {
      _categoryId = categoryId;
    }
    if (drivingLicense != null) {
      _drivingLicense = drivingLicense;
    }
    if (numberPlate != null) {
      _numberPlate = numberPlate;
    }
    if (bankId != null) {
      _bankId = bankId;
    }
    if (bankAccount != null) {
      _bankAccount = bankAccount;
    }
    if (isRead != null) {
      _isRead = isRead;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get nameAr => _nameAr;
  set nameAr(String? nameAr) => _nameAr = nameAr;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get image => _image;
  set image(String? image) => _image = image;
  String? get emailVerifiedAt => _emailVerifiedAt;
  set emailVerifiedAt(String? emailVerifiedAt) =>
      _emailVerifiedAt = emailVerifiedAt;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get otp => _otp;
  set otp(String? otp) => _otp = otp;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get userType => _userType;
  set userType(String? userType) => _userType = userType;
  String? get streetAddress => _streetAddress;
  set streetAddress(String? streetAddress) => _streetAddress = streetAddress;
  String? get city => _city;
  set city(String? city) => _city = city;
  String? get state => _state;
  set state(String? state) => _state = state;
  String? get postalCode => _postalCode;
  set postalCode(String? postalCode) => _postalCode = postalCode;
  String? get country => _country;
  set country(String? country) => _country = country;
  String? get latitude => _latitude;
  set latitude(String? latitude) => _latitude = latitude;
  String? get longitude => _longitude;
  set longitude(String? longitude) => _longitude = longitude;
  String? get twitter => _twitter;
  set twitter(String? twitter) => _twitter = twitter;
  String? get facebook => _facebook;
  set facebook(String? facebook) => _facebook = facebook;
  String? get instagram => _instagram;
  set instagram(String? instagram) => _instagram = instagram;
  String? get linkedin => _linkedin;
  set linkedin(String? linkedin) => _linkedin = linkedin;
  String? get categoryId => _categoryId;
  set categoryId(String? categoryId) => _categoryId = categoryId;
  String? get drivingLicense => _drivingLicense;
  set drivingLicense(String? drivingLicense) =>
      _drivingLicense = drivingLicense;
  String? get numberPlate => _numberPlate;
  set numberPlate(String? numberPlate) => _numberPlate = numberPlate;
  String? get bankId => _bankId;
  set bankId(String? bankId) => _bankId = bankId;
  String? get bankAccount => _bankAccount;
  set bankAccount(String? bankAccount) => _bankAccount = bankAccount;
  String? get isRead => _isRead;
  set isRead(String? isRead) => _isRead = isRead;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _nameAr = json['name_ar'];
    _email = json['email'];
    _image = json['image'];
    _emailVerifiedAt = json['email_verified_at'];
    _mobile = json['mobile'];
    _otp = json['otp'];
    _status = json['status'];
    _userType = json['user_type'];
    _streetAddress = json['street_address'];
    _city = json['city'];
    _state = json['state'];
    _postalCode = json['postal_code'];
    _country = json['country'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _twitter = json['twitter'];
    _facebook = json['facebook'];
    _instagram = json['instagram'];
    _linkedin = json['linkedin'];
    _categoryId = json['category_id'];
    _drivingLicense = json['driving_license'];
    _numberPlate = json['number_plate'];
    _bankId = json['bank_id'];
    _bankAccount = json['bank_account'];
    _isRead = json['is_read'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['name_ar'] = _nameAr;
    data['email'] = _email;
    data['image'] = _image;
    data['email_verified_at'] = _emailVerifiedAt;
    data['mobile'] = _mobile;
    data['otp'] = _otp;
    data['status'] = _status;
    data['user_type'] = _userType;
    data['street_address'] = _streetAddress;
    data['city'] = _city;
    data['state'] = _state;
    data['postal_code'] = _postalCode;
    data['country'] = _country;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['twitter'] = _twitter;
    data['facebook'] = _facebook;
    data['instagram'] = _instagram;
    data['linkedin'] = _linkedin;
    data['category_id'] = _categoryId;
    data['driving_license'] = _drivingLicense;
    data['number_plate'] = _numberPlate;
    data['bank_id'] = _bankId;
    data['bank_account'] = _bankAccount;
    data['is_read'] = _isRead;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class Links {
  String? _url;
  String? _label;
  bool? _active;

  Links({String? url, String? label, bool? active}) {
    if (url != null) {
      _url = url;
    }
    if (label != null) {
      _label = label;
    }
    if (active != null) {
      _active = active;
    }
  }

  String? get url => _url;
  set url(String? url) => _url = url;
  String? get label => _label;
  set label(String? label) => _label = label;
  bool? get active => _active;
  set active(bool? active) => _active = active;

  Links.fromJson(Map<String, dynamic> json) {
    _url = json['url'];
    _label = json['label'];
    _active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = _url;
    data['label'] = _label;
    data['active'] = _active;
    return data;
  }
}
