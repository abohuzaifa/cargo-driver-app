import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../alltrips/controller/find_trip_controller.dart';
import '../alltrips/model/find_tripmodel.dart';
import '../api/api_constants.dart';
import '../constant/colors_utils.dart';
import '../main.dart';
import '../profile/profile_page.dart';
import '../widgets/custom_button.dart';
import 'controller/location_controller.dart';
import 'controller/ridetrcaking_controller.dart';

class FindTripOnline extends StatefulWidget {
  final RemoteMessage?
      message; // Define a nullable variable to store the message

  FindTripOnline({Key? key, this.message}) : super(key: key);

  @override
  State<FindTripOnline> createState() => _FindTripOnlineState();
}

class _FindTripOnlineState extends State<FindTripOnline> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final List<TripData> _trips = [];
  bool _isLoading = false;
  RxBool requestReceived = false.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadTrips();
    if (widget.message != null) {
      print('In Ui message');

      requestReceived.value = true;
    } else {
      print('In Ui no message');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadMoreTrips();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
        leading: InkWell(
          onTap: () => _key.currentState?.openDrawer(),
          child: const Icon(Icons.menu),
        ),
      ),
      key: _key,
      drawer: const Drawer(
        child: ProfilePage(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            foregroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [bgColor, bgColor.withOpacity(0.01)],
              ),
            ),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: Get.find<LocationController>().initialPos,
              ),
              myLocationEnabled: false,
              compassEnabled: false,
              onCameraIdle: () async {},
            ),
          ),
          requestReceived.value == false
              ? newRequest(_trips, _scrollController)
              : Container(),
          requestReceived.value == true
              ?
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), // Margin adjusted for mobile devices
            height: MediaQuery.of(context).size.height * 0.4, // Height adjusted for mobile devices
            width: MediaQuery.of(context).size.width * 0.8, // Width adjusted for mobile devices
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Received New Request',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.only(
                      left: 20,right: 20
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06, // Height adjusted for mobile devices
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle accept action
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey, // Set the button color here
                              ),
                              child: Text('Accept',style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.05), // Width adjusted for mobile devices
                        Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.06, // Height adjusted for mobile devices
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle reject action
                                setState(() {
                                  requestReceived.value=false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey, // Set the button color here
                              ),
                              child: Text('Reject',style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )

              : Container()
        ],
      ),
    );
  }
}

Widget newRequest(List<TripData> data, ScrollController scrollController) {
  final amonutController = TextEditingController();
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
    child: data.isEmpty
        ? Center(
            child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('No Data Found!')),
          )
        : ListView.builder(
            controller: scrollController,
            itemCount: data.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: (_) => Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 8, bottom: 8),
                              margin: const EdgeInsets.only(top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 0,
                                    offset: const Offset(0.0, 0.0),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month,
                                                color: Colors.black, size: 16),
                                            const SizedBox(width: 8),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 2),
                                              child: Text(
                                                  '${data[index].createdAt}',
                                                  style: const TextStyle(
                                                      fontSize: 14)),
                                            ),
                                          ],
                                        ),
                                        Text('${'Ride'} #${data[index].id}',
                                            style:
                                                const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    const Divider(height: 24, thickness: 0.5),
                                    Row(
                                      children: [
                                        const Column(
                                          children: [
                                            Icon(Icons.near_me,
                                                color: Colors.green, size: 18),
                                            SizedBox(height: 2),
                                            SizedBox(
                                              height: 34,
                                              child: DottedLine(
                                                direction: Axis.vertical,
                                                lineLength: double.infinity,
                                                lineThickness: 1,
                                                dashLength: 2,
                                                dashColor: Colors.black,
                                              ),
                                            ),
                                            SizedBox(height: 2),
                                            Icon(Icons.location_on,
                                                color: Colors.red, size: 18),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 2),
                                              Text(
                                                  data[index].parcelAddress ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  maxLines: 2),
                                              const SizedBox(height: 22),
                                              Text(
                                                  data[index].receiverAddress ??
                                                      '',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  maxLines: 2),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Price',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const Spacer(),
                                                  Flexible(
                                                    child: TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                        counterText: '',
                                                        contentPadding:
                                                            EdgeInsets.all(1),
                                                        constraints:
                                                            BoxConstraints(),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          13),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          13),
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          13),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          13),
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        errorBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          13),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          13),
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topRight: Radius
                                                                      .circular(
                                                                          13),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          13),
                                                                ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "123456789",
                                                        errorStyle: TextStyle(
                                                            height: 0.05),
                                                        hintStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.grey),
                                                      ),
                                                      controller:
                                                          amonutController
                                                            ..text = data[index]
                                                                    .amount ??
                                                                '',
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomButton(
                                            width: 180,
                                            buttonText: 'Cancel',
                                            onPress: () {
                                              Get.back();
                                            }),
                                        CustomButton(
                                            width: 180,
                                            buttonText: 'Bid Your Price',
                                            onPress: () async {
                                              Get.back();
                                              await Get.find<
                                                      RideTrackingController>()
                                                  .bidOnUserRequests(
                                                      requestId:
                                                          '${data[index].id ?? ''}',
                                                      amount: amonutController
                                                          .text);
                                            })
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: curvedBlueColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Image.asset(
                          'assets/images/trp.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data[index].user?.name ?? ''),
                          Text(
                            '${data[index].parcelAddress?.substring(0, 10)} To ${data[index].receiverAddress?.substring(0, 10)}',
                            style: const TextStyle(fontSize: 11),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
