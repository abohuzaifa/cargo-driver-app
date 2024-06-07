class TransactionHistoryModel {
  String? balance;
  dynamic totalEarning;
  dynamic totalWithdraw;
  List<Transactions>? transactions;

  TransactionHistoryModel(
      {this.balance, this.totalEarning, this.totalWithdraw, this.transactions});

  TransactionHistoryModel.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    totalEarning = json['total_earning'];
    totalWithdraw = json['total_withdraw'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['total_earning'] = totalEarning;
    data['total_withdraw'] = totalWithdraw;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  int? id;
  String? offerId;
  String? parcelAddress;
  String? receiverAddress;
  String? amount;

  Transactions(
      {this.id,
      this.offerId,
      this.parcelAddress,
      this.receiverAddress,
      this.amount});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    offerId = json['offer_id'];
    parcelAddress = json['parcel_address'];
    receiverAddress = json['receiver_address'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['offer_id'] = offerId;
    data['parcel_address'] = parcelAddress;
    data['receiver_address'] = receiverAddress;
    data['amount'] = amount;
    return data;
  }
}
