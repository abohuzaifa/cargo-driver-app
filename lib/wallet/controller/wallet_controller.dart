import 'package:cargo_driver_app/alltrips/model/recent_transaction_model.dart';
import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/api/user_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WalletController extends GetxController implements GetxService {
  final UserRepo userRepo;
  WalletController({required this.userRepo});
  var transactionModel = Rx<TransactionHistoryModel?>(null);
  Future<Map<String, dynamic>> getTransactions() async {
    var response = await userRepo.getTransactionHistory();
    if (response.containsKey(APIRESPONSE.SUCCESS)) {
      return response;
    } else {
      showCupertinoModalPopup(
          context: Get.context!,
          builder: (_) => CupertinoAlertDialog(
                actions: [
                  CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Ok'))
                ],
              ));
    }
    return response;
  }

  @override
  void onReady() {
    Future.wait([getTransactions()]);
    super.onReady();
  }
}
