class MDCreateHistory {
  String? msg;
  Data? data;

  MDCreateHistory({this.msg, this.data});

  MDCreateHistory.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? requestId;
  String? lat;
  String? long;
  String? address;
  String? isStart;
  String? isEnd;
  int? userId;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.requestId,
        this.lat,
        this.long,
        this.address,
        this.isStart,
        this.isEnd,
        this.userId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    requestId = json['request_id'];
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    isStart = json['is_start'];
    isEnd = json['is_end'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['request_id'] = this.requestId;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['is_start'] = this.isStart;
    data['is_end'] = this.isEnd;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
