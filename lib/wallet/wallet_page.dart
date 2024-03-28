import 'package:flutter/material.dart';
import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                  const Text('YOUR BALANCE'),
                  Text(
                    'SAR : 5400',
                    style: TextStyle(fontSize: 20.sp, color: curvedBlueColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
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
                          child: Image.asset('assets/images/earning.png'),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text('SAR : 500'),
                        const Text('Total Earning')
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
                          child: Image.asset('assets/images/earning.png'),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        const Text('SAR : 3400'),
                        const Text('Total Withdraw')
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
                      const Text('Transactions'),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Text(
                          'See All',
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0; i < 5; i++)
                    const ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Makkah To Madina'),
                      trailing: Text('SAR 75'),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
