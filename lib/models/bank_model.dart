class BankModel {
  List<Banks>? banks;

  BankModel({this.banks});

  BankModel.fromJson(Map<String, dynamic> json) {
    if (json['banks'] != null) {
      banks = <Banks>[];
      json['banks'].forEach((v) {
        banks!.add(Banks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (banks != null) {
      data['banks'] = banks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Banks {
  int? id;
  String? name;
  String? branchCode;
  int? status;
  String? createdAt;
  String? updatedAt;

  Banks(
      {this.id,
      this.name,
      this.branchCode,
      this.status,
      this.createdAt,
      this.updatedAt});

  Banks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    branchCode = json['branch_code'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['branch_code'] = branchCode;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
