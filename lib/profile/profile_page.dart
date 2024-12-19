import 'package:cargo_driver_app/api/auth_controller.dart';
import 'package:cargo_driver_app/home/home_screen.dart';
import 'package:cargo_driver_app/home/vehicle_setting.dart';
import 'package:cargo_driver_app/more/more_view.dart';
import 'package:cargo_driver_app/profile/controller/profile_controller.dart';

import '../../alltrips/all_trip_page.dart';
import '../../notification/notifcation_page.dart';
import '../../payment/payment_page.dart';
import '../../profile/update_profile.dart';
import '../../widgets/build_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../constant/colors_utils.dart';
import '../wallet/wallet_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0.5, 0.5),
              colors: [
                bgColor,
                bgColor.withOpacity(0.1),
                bgColor.withOpacity(0.1),
                bgColor.withOpacity(0.1)
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0.h),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: textBrownColor,
                            child: Image.asset(
                              'assets/images/profile.png',
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Text(
                            Get.find<AuthController>()
                                    .getLoginUserData()
                                    ?.user
                                    ?.name ??
                                '',
                            style: TextStyle(fontSize: 20.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ListTile(
                      // onTap: () => Get.to(() => UpdateProfile()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/languageIcon.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Change Language'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        // Show dialog to select language
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: Text('Select Language'.tr),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    // Change language to English
                                    Get.updateLocale(Locale('en', 'US'));
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('English'.tr),
                                ),
                                SimpleDialogOption(
                                  onPressed: () {
                                    // Change language to Arabic
                                    Get.updateLocale(Locale('ar', 'SA'));
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Arabic'.tr),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const HomeScreen()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/profile_icon.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'DashBoard'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const WalletPage()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/wallet.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Balance'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => UpdateProfile()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/profile_icon.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Profile'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => VehicleSettingPage()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/setting.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Vehicle Setting'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const AllTripsPage()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/driver_way.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Trips'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const NotificationPage()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/notification.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Notifications'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.to(() => const PaymentPage()),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/payment.png',
                        color: Colors.black,
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Payment'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    ListTile(
                      onTap: () => buildDialog(
                          onPress1: Get.back,
                          onPress2: () async {
                            Get.back();
                            await Get.find<ProfileController>().deleteAccount();
                          },
                          btntext1: 'NO'.tr,
                          btntext2: 'YES'.tr,
                          btnColor2: Colors.redAccent,
                          height: 40,
                          width: 60,
                          isDelete: true,
                          title: 'Delete Account'.tr,
                          subtitle:
                              'Are You Sure You Want To\n Delete Your Account?'.tr),
                      dense: true,
                      leading: Image.asset(
                        'assets/images/deletacnt.png',
                        height: 20.h,
                        width: 20.h,
                      ),
                      title: Text(
                        'Delete Account'.tr,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () => buildDialog(
                          onPress1: () {
                            Get.back();
                          },
                          onPress2: () async {
                            Get.back();
                            await Get.find<ProfileController>().logout();
                          },
                          btntext1: 'NO'.tr,
                          btntext2: 'YES'.tr,
                          height: 40,
                          width: 60,
                          isDelete: false,
                          title: 'Sign Out'.tr,
                          subtitle: 'Are You Sure You Want To\nSign Out?'.tr),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Icon(Icons.logout), Text('Sign Out'.tr)],
                      ),
                    ),
                    // const Spacer(),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
