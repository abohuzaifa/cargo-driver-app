import 'package:cargo_driver_app/alltrips/controller/find_trip_controller.dart';
import 'package:cargo_driver_app/alltrips/model/find_tripmodel.dart';
import 'package:cargo_driver_app/api/api_constants.dart';

import 'package:cargo_driver_app/constant/colors_utils.dart';

import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:cargo_driver_app/widgets/custom_button.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../home/controller/ridetrcaking_controller.dart';
import '../widgets/serch_delegate.dart';

class FindTripPage extends StatefulWidget {
  const FindTripPage({super.key});

  @override
  State<FindTripPage> createState() => _FindTripPageState();
}

class _FindTripPageState extends State<FindTripPage> {
  final _amountController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final List<TripData> _trips = [];
  bool _isLoading = false;

  Future<void> _loadTrips() async {
    setState(() {
      _isLoading = true;
    });
    var data = await Get.find<FindTripController>()
        .getAllUserTrips(page: _currentPage);
    var trips = FindTripModel.fromJson(data[APIRESPONSE.SUCCESS]).data?.data;

    if (mounted) {
      setState(() {
        _trips.addAll(trips ?? []);
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreTrips() async {
    setState(() {
      _isLoading = true;
    });
    _currentPage++;
    var data = await Get.find<FindTripController>()
        .getAllUserTrips(page: _currentPage);
    var moreTrips =
        FindTripModel.fromJson(data[APIRESPONSE.SUCCESS]).data?.data;

    setState(() {
      _trips.addAll(moreTrips ?? []);
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreTrips();
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _loadTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Trips'),
        ),
        body: Center(
            child: Container(
          child: Text('Coming Soon'),
        ))
        // FutureBuilder(
        //     future: Get.find<FindTripController>()
        //         .getAllUserTrips(page: _currentPage),l
        //     initialData: const [],
        //     builder: (ctx, AsyncSnapshot snapShot) {
        //       if (snapShot.connectionState == ConnectionState.done) {
        //         var data =
        //             FindTripModel.fromJson(snapShot.data[APIRESPONSE.SUCCESS])
        //                 .data;
        //         return Container(
        //           decoration: BoxDecoration(
        //             gradient: LinearGradient(
        //               begin: Alignment.topCenter,
        //               colors: [bgColor, bgColor.withOpacity(0.01)],
        //             ),
        //           ),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               buildBackButton(
        //                 context,
        //                 isAction: true,
        //                 onTap: Get.back,
        //                 onSearch: () {
        //                   showSearch(
        //                       context: context,
        //                       delegate:
        //                           CustomSearchDelegate(searchList: data?.data
        //                               // controller.allTrips.value?.data?.data
        //                               ));
        //                 },
        //               ),
        //               SizedBox(
        //                 height: 50.h,
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 30.h),
        //                 child: const Text('FIND YOUR TRIP'),
        //               ),
        //               Expanded(
        //                 child: Padding(
        //                   padding: EdgeInsets.symmetric(
        //                       vertical: 16.h, horizontal: 20.w),
        //                   child: ListView.builder(
        //                       controller: ScrollController(),
        //                       itemCount: data?.data?.length ?? 0,
        //                       shrinkWrap: true,
        //                       itemBuilder: (context, index) {
        //                         return InkWell(
        //                           onTap: () {
        //                             showBottomSheet(
        //                                 backgroundColor: Colors.white,
        //                                 context: context,
        //                                 builder: (_) => Wrap(
        //                                       children: [
        //                                         Column(
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment.start,
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           mainAxisSize: MainAxisSize.min,
        //                                           children: [
        //                                             Container(
        //                                               padding:
        //                                                   const EdgeInsets.only(
        //                                                       top: 8, bottom: 8),
        //                                               margin:
        //                                                   const EdgeInsets.only(
        //                                                       top: 8, bottom: 8),
        //                                               decoration: BoxDecoration(
        //                                                 color: Colors.white,
        //                                                 borderRadius:
        //                                                     BorderRadius.circular(
        //                                                         8),
        //                                                 boxShadow: [
        //                                                   BoxShadow(
        //                                                       color: Colors.grey
        //                                                           .withOpacity(
        //                                                               0.4),
        //                                                       blurRadius: 10,
        //                                                       spreadRadius: 0,
        //                                                       offset:
        //                                                           const Offset(
        //                                                               0.0, 0.0)),
        //                                                 ],
        //                                               ),
        //                                               child: Container(
        //                                                 padding:
        //                                                     const EdgeInsets.all(
        //                                                         8),
        //                                                 child: Column(
        //                                                   crossAxisAlignment:
        //                                                       CrossAxisAlignment
        //                                                           .start,
        //                                                   children: [
        //                                                     Row(
        //                                                       mainAxisAlignment:
        //                                                           MainAxisAlignment
        //                                                               .spaceBetween,
        //                                                       children: [
        //                                                         Row(
        //                                                           children: [
        //                                                             const Icon(
        //                                                                 Icons
        //                                                                     .calendar_month,
        //                                                                 color: Colors
        //                                                                     .black,
        //                                                                 size: 16),
        //                                                             const SizedBox(
        //                                                                 width: 8),
        //                                                             Padding(
        //                                                               padding: const EdgeInsets
        //                                                                   .only(
        //                                                                   top: 2),
        //                                                               child: Text(
        //                                                                   '${(data?.data?[index].createdAt)}',
        //                                                                   style: const TextStyle(
        //                                                                       fontSize:
        //                                                                           14)),
        //                                                             ),
        //                                                           ],
        //                                                         ),
        //                                                         Text(
        //                                                             '${'Ride'} #${data?.data?[index].id}',
        //                                                             style: const TextStyle(
        //                                                                 fontSize:
        //                                                                     14)),
        //                                                       ],
        //                                                     ),
        //                                                     const Divider(
        //                                                         height: 24,
        //                                                         thickness: 0.5),
        //                                                     Row(
        //                                                       children: [
        //                                                         const Column(
        //                                                           children: [
        //                                                             Icon(
        //                                                                 Icons
        //                                                                     .near_me,
        //                                                                 color: Colors
        //                                                                     .green,
        //                                                                 size: 18),
        //                                                             SizedBox(
        //                                                                 height:
        //                                                                     2),
        //                                                             SizedBox(
        //                                                               height: 34,
        //                                                               child:
        //                                                                   DottedLine(
        //                                                                 direction:
        //                                                                     Axis.vertical,
        //                                                                 lineLength:
        //                                                                     double
        //                                                                         .infinity,
        //                                                                 lineThickness:
        //                                                                     1,
        //                                                                 dashLength:
        //                                                                     2,
        //                                                                 dashColor:
        //                                                                     Colors
        //                                                                         .black,
        //                                                               ),
        //                                                             ),
        //                                                             SizedBox(
        //                                                                 height:
        //                                                                     2),
        //                                                             Icon(
        //                                                                 Icons
        //                                                                     .location_on,
        //                                                                 color: Colors
        //                                                                     .red,
        //                                                                 size: 18),
        //                                                           ],
        //                                                         ),
        //                                                         const SizedBox(
        //                                                             width: 16),
        //                                                         Expanded(
        //                                                           child: Column(
        //                                                             crossAxisAlignment:
        //                                                                 CrossAxisAlignment
        //                                                                     .start,
        //                                                             children: [
        //                                                               const SizedBox(
        //                                                                   height:
        //                                                                       2),
        //                                                               Text(
        //                                                                   data?.data?[index].parcelAddress ??
        //                                                                       '',
        //                                                                   style: const TextStyle(
        //                                                                       fontSize:
        //                                                                           14),
        //                                                                   maxLines:
        //                                                                       2),
        //                                                               const SizedBox(
        //                                                                   height:
        //                                                                       22),
        //                                                               Text(
        //                                                                   data?.data?[index].receiverAddress ??
        //                                                                       '',
        //                                                                   style: const TextStyle(
        //                                                                       fontSize:
        //                                                                           14),
        //                                                                   maxLines:
        //                                                                       2),
        //                                                               Row(
        //                                                                 mainAxisAlignment:
        //                                                                     MainAxisAlignment
        //                                                                         .spaceBetween,
        //                                                                 children: [
        //                                                                   const Text(
        //                                                                     'Price',
        //                                                                     style: TextStyle(
        //                                                                         fontSize: 15,
        //                                                                         fontWeight: FontWeight.bold),
        //                                                                   ),
        //                                                                   const Spacer(),
        //                                                                   Flexible(
        //                                                                       child: TextFormField(
        //                                                                           decoration: const InputDecoration(
        //                                                                             counterText: '',
        //                                                                             contentPadding: EdgeInsets.all(1),
        //                                                                             constraints: BoxConstraints(),
        //                                                                             enabledBorder: OutlineInputBorder(
        //                                                                                 borderRadius: BorderRadius.only(
        //                                                                                   topRight: Radius.circular(13),
        //                                                                                   bottomRight: Radius.circular(13),
        //                                                                                 ),
        //                                                                                 borderSide: BorderSide.none),
        //                                                                             focusedBorder: OutlineInputBorder(
        //                                                                                 borderRadius: BorderRadius.only(
        //                                                                                   topRight: Radius.circular(13),
        //                                                                                   bottomRight: Radius.circular(13),
        //                                                                                 ),
        //                                                                                 borderSide: BorderSide.none),
        //                                                                             errorBorder: OutlineInputBorder(
        //                                                                                 borderRadius: BorderRadius.only(
        //                                                                                   topRight: Radius.circular(13),
        //                                                                                   bottomRight: Radius.circular(13),
        //                                                                                 ),
        //                                                                                 borderSide: BorderSide.none),
        //                                                                             disabledBorder: OutlineInputBorder(
        //                                                                                 borderRadius: BorderRadius.only(
        //                                                                                   topRight: Radius.circular(13),
        //                                                                                   bottomRight: Radius.circular(13),
        //                                                                                 ),
        //                                                                                 borderSide: BorderSide.none),
        //                                                                             filled: true,
        //                                                                             fillColor: Colors.white,
        //                                                                             border: InputBorder.none,
        //                                                                             hintText: "123456789",
        //                                                                             errorStyle: TextStyle(height: 0.05),
        //                                                                             hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        //                                                                           ),
        //                                                                           controller: _amountController..text = data?.data?[index].amount ?? '')),
        //                                                                 ],
        //                                                               )
        //                                                             ],
        //                                                           ),
        //                                                         ),
        //                                                       ],
        //                                                     ),
        //                                                     Row(
        //                                                       mainAxisAlignment:
        //                                                           MainAxisAlignment
        //                                                               .spaceBetween,
        //                                                       children: [
        //                                                         CustomButton(
        //                                                             width: 180,
        //                                                             buttonText:
        //                                                                 'Cancel',
        //                                                             onPress: () {
        //                                                               Get.back();
        //                                                             }),
        //                                                         CustomButton(
        //                                                             width: 180,
        //                                                             buttonText:
        //                                                                 'Bid Your Price',
        //                                                             onPress:
        //                                                                 () async {
        //                                                               Get.back();
        //                                                               await Get.find<RideTrackingController>().bidOnUserRequests(
        //                                                                   requestId:
        //                                                                       '${data?.data?[index].id ?? ''}',
        //                                                                   amount:
        //                                                                       _amountController.text);
        //                                                             })
        //                                                       ],
        //                                                     )
        //                                                   ],
        //                                                 ),
        //                                               ),
        //                                             ),
        //                                           ],
        //                                         )
        //                                       ],
        //                                     ));
        //                           },
        //                           child: Container(
        //                             margin: const EdgeInsets.all(2),
        //                             decoration: BoxDecoration(
        //                                 borderRadius: BorderRadius.circular(8),
        //                                 color: Colors.white),
        //                             child:
        //                             Row(
        //                               children: [
        //                                 Container(
        //                                   margin: const EdgeInsets.all(8),
        //                                   padding: const EdgeInsets.all(16),
        //                                   decoration: BoxDecoration(
        //                                       color: curvedBlueColor,
        //                                       borderRadius:
        //                                           BorderRadius.circular(8)),
        //                                   child: Image.asset(
        //                                     'assets/images/trp.png',
        //                                     fit: BoxFit.cover,
        //                                   ),
        //                                 ),
        //                                 Column(
        //                                   mainAxisAlignment:
        //                                       MainAxisAlignment.start,
        //                                   crossAxisAlignment:
        //                                       CrossAxisAlignment.start,
        //                                   children: [
        //                                     Text(data?.data?[index].user?.name ??
        //                                         ''),
        //                                     Text(
        //                                       '${data?.data?[index].parcelAddress ?? ''} To ${data?.data?[index].receiverAddress ?? ''}',
        //                                       style:
        //                                           const TextStyle(fontSize: 11),
        //                                     )
        //                                   ],
        //                                 )
        //                               ],
        //                             ),
        //                           ),
        //                         );
        //                       }),
        //                 ),
        //               )
        //             ],
        //           ),
        //         );
        //       }
        //       if (snapShot.connectionState == ConnectionState.waiting) {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //       return const Center(
        //         child: Text('no data'),
        //       );
        //     }),
        );
  }
}
