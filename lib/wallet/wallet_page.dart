import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/api/user_repo.dart';

import 'package:cargo_driver_app/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../alltrips/model/recent_transaction_model.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future:
              Get.put(WalletController(userRepo: UserRepo())).getTransactions(),
          initialData: const [],
          builder: (ctx, AsyncSnapshot snapShot) {
            if (snapShot.connectionState == ConnectionState.done &&
                snapShot.hasData) {
              var data = TransactionHistoryModel.fromJson(
                  snapShot.data[APIRESPONSE.SUCCESS]);

              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [bgColor, bgColor.withOpacity(0.01)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBackButton(context, isAction: true),
                    SizedBox(
                      height: 50.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('YOUR BALANCE'.tr),
                          Text(
                            'SAR : ${data.balance ?? '0.0'}',
                            style: TextStyle(
                                fontSize: 20.sp, color: curvedBlueColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 40.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1.0,
                                      offset: Offset(1, 2))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child:
                                      Image.asset('assets/images/earning.png'),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text('SAR :${data.totalEarning} '),
                                //${controller.transactionModel.value?.totalEarning ?? '0.0'}
                                Text('Total Earning'.tr)
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1.0,
                                      offset: Offset(1, 2))
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child:
                                      Image.asset('assets/images/earning.png'),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text('SAR : ${data.totalWithdraw}'),
                                //${controller.transactionModel.value?.totalWithdraw ?? "0.0"}
                                Text('Total Withdraw'.tr)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          shape: BoxShape.rectangle),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Transactions'.tr),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Text(
                                  'See All'.tr,
                                  style: TextStyle(fontSize: 11.sp),
                                ),
                              ),
                            ],
                          ),
                          if (data.transactions?.isNotEmpty ?? false)
                            for (int i = 0; i < data.transactions!.length; i++)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                    '${data.transactions?[i].parcelAddress?.substring(0, 8)} To ${data.transactions?[i].receiverAddress?.substring(0, 8)}'),
                                trailing: Text(
                                    'SAR ${data.transactions?[i].amount ?? '0.0'}'),
                              )
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return const Center(
              child: Text('No data'),
            );
          }),
    );
  }
}
