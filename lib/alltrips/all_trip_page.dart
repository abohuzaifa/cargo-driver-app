import 'package:cargo_driver_app/alltrips/controller/find_trip_controller.dart';
import 'package:cargo_driver_app/api/api_constants.dart';
import 'package:cargo_driver_app/api/auth_controller.dart';

import '../../widgets/back_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constant/colors_utils.dart';
import 'model/find_tripmodel.dart';

class AllTripsPage extends StatelessWidget {
  const AllTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Get.find<FindTripController>().getAllUserTrips(page: 1),
          initialData: const [],
          builder: (ctx, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              var data =
                  FindTripModel.fromJson(snapshot.data[APIRESPONSE.SUCCESS])
                      .data;
              return Container(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: buildBackButton(
                        context,
                        isAction: true,
                        isTitle: false,
                        onTap: () => Get.back(),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0.h),
                      child: Text(
                        'All TRIPS',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16.sp,
                            color: textcyanColor),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8.0.h),
                        child: CustomScrollView(
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Container(
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color(0xffFFFFFF),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(Get.find<AuthController>()
                                                        .getLoginUserData()
                                                        ?.user
                                                        ?.name ??
                                                    ''),
                                                Text(
                                                    'Trip ID: ${data?.data?[index].id}')
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            RichText(
                                                text: TextSpan(children: [
                                              TextSpan(
                                                  text: data?.data?[index]
                                                          .parcelAddress ??
                                                      '',
                                                  style: TextStyle(
                                                      color: textBrownColor)),
                                              const TextSpan(
                                                  text: ' To ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              TextSpan(
                                                  text: data?.data?[index]
                                                          .receiverAddress ??
                                                      '',
                                                  style: TextStyle(
                                                      color: textBrownColor))
                                            ])),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                                ' Earning: SAR ${data?.data?[index].amount}'),
                                          ],
                                        ),
                                      ),
                                  childCount: data?.data?.length),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
            return const Center(
              child: Text('No Data'),
            );
          }),
    );
  }
}
