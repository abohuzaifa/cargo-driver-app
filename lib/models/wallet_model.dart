// ignore_for_file: unnecessary_getters_setters

class WalletModel {
  String? _earnings;
  int? _withdral;
  String? _balance;
  CurrentEarning? _currentEarning;

  WalletModel(
      {String? earnings,
      int? withdral,
      String? balance,
      CurrentEarning? currentEarning}) {
    if (earnings != null) {
      _earnings = earnings;
    }
    if (withdral != null) {
      _withdral = withdral;
    }
    if (balance != null) {
      _balance = balance;
    }
    if (currentEarning != null) {
      _currentEarning = currentEarning;
    }
  }

  String? get earnings => _earnings;
  set earnings(String? earnings) => _earnings = earnings;
  int? get withdral => _withdral;
  set withdral(int? withdral) => _withdral = withdral;
  String? get balance => _balance;
  set balance(String? balance) => _balance = balance;
  CurrentEarning? get currentEarning => _currentEarning;
  set currentEarning(CurrentEarning? currentEarning) =>
      _currentEarning = currentEarning;

  WalletModel.fromJson(Map<String, dynamic> json) {
    _earnings = json['earnings'];
    _withdral = json['withdral'];
    _balance = json['balance'];
    _currentEarning = json['current_earning'] != null
        ? CurrentEarning.fromJson(json['current_earning'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['earnings'] = _earnings;
    data['withdral'] = _withdral;
    data['balance'] = _balance;
    if (_currentEarning != null) {
      data['current_earning'] = _currentEarning!.toJson();
    }
    return data;
  }
}

class CurrentEarning {
  int? _id;
  String? _walletId;
  String? _amount;
  String? _isDeposite;
  String? _isExpanse;
  String? _description;
  String? _orderId;
  String? _invoiceId;
  String? _createdAt;
  String? _updatedAt;
  String? _isRead;

  CurrentEarning(
      {int? id,
      String? walletId,
      String? amount,
      String? isDeposite,
      String? isExpanse,
      String? description,
      String? orderId,
      String? invoiceId,
      String? createdAt,
      String? updatedAt,
      String? isRead}) {
    if (id != null) {
      _id = id;
    }
    if (walletId != null) {
      _walletId = walletId;
    }
    if (amount != null) {
      _amount = amount;
    }
    if (isDeposite != null) {
      _isDeposite = isDeposite;
    }
    if (isExpanse != null) {
      _isExpanse = isExpanse;
    }
    if (description != null) {
      _description = description;
    }
    if (orderId != null) {
      _orderId = orderId;
    }
    if (invoiceId != null) {
      _invoiceId = invoiceId;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
    if (isRead != null) {
      _isRead = isRead;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get walletId => _walletId;
  set walletId(String? walletId) => _walletId = walletId;
  String? get amount => _amount;
  set amount(String? amount) => _amount = amount;
  String? get isDeposite => _isDeposite;
  set isDeposite(String? isDeposite) => _isDeposite = isDeposite;
  String? get isExpanse => _isExpanse;
  set isExpanse(String? isExpanse) => _isExpanse = isExpanse;
  String? get description => _description;
  set description(String? description) => _description = description;
  String? get orderId => _orderId;
  set orderId(String? orderId) => _orderId = orderId;
  String? get invoiceId => _invoiceId;
  set invoiceId(String? invoiceId) => _invoiceId = invoiceId;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  String? get isRead => _isRead;
  set isRead(String? isRead) => _isRead = isRead;

  CurrentEarning.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _walletId = json['wallet_id'];
    _amount = json['amount'];
    _isDeposite = json['is_deposite'];
    _isExpanse = json['is_expanse'];
    _description = json['description'];
    _orderId = json['order_id'];
    _invoiceId = json['invoice_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['wallet_id'] = _walletId;
    data['amount'] = _amount;
    data['is_deposite'] = _isDeposite;
    data['is_expanse'] = _isExpanse;
    data['description'] = _description;
    data['order_id'] = _orderId;
    data['invoice_id'] = _invoiceId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['is_read'] = _isRead;
    return data;
  }
}
