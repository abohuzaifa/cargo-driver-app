import 'package:cargo_driver_app/alltrips/add_trip/add_trip_logic.dart';
import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';
import 'package:cargo_driver_app/util/apputils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:cargo_driver_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'add_trip_model.dart';

class AddTripView extends StatefulWidget {
  const AddTripView({super.key});

  @override
  State<AddTripView> createState() => _AddTripViewState();
}

class _AddTripViewState extends State<AddTripView> {
  final _fromCity = TextEditingController(), _toCity = TextEditingController();
  final selectedTime = Rx<TimeOfDay?>(null);
  final _formKey = GlobalKey<FormState>();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddTripController>(
        init: AddTripController(),
        builder: (logic) {
          return Obx(
            () => Scaffold(
              resizeToAvoidBottomInset: true,
              body: logic.isLoading.value == true
                  ? Center(
                      child: CircularProgressIndicator(
                        color: textcyanColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Container(
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
                            buildBackButton(context,
                                isAction: true, onTap: Get.back),
                            SizedBox(
                              height: 50.h,
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 30.h),
                                  child: Text('Add Your Trip'.tr),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 40.w),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          // Ensures the container takes full width
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(13.0),
                                          ),
                                          child: CustomPopup(
                                            mdCities: logic.mdCities,
                                            hint: "From:".tr,
                                            onValueChanged: (value) {
                                              logic.fromValue = value;
                                              logic.selectedCityFromId = logic
                                                  .mdCities
                                                  .firstWhere((city) =>
                                                      city.cityName == value)
                                                  .sno!;
                                              print(
                                                  "Selected From City ID: ${logic.selectedCityFromId}");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          // Ensures the container takes full width
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(13.0),
                                          ),
                                          child: CustomPopup(
                                            mdCities: logic.mdCities,
                                            hint: "To:".tr,
                                            onValueChanged: (value) {
                                              logic.toValue = value;
                                              logic.selectedCityToId = logic
                                                  .mdCities
                                                  .firstWhere((city) =>
                                                      city.cityName == value)
                                                  .sno!;
                                              print(
                                                  "Selected To City ID: ${logic.selectedCityToId}");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              logic.selectDate(context),

                                          //     showDatePicker(
                                          //   context: context,
                                          //   firstDate: DateTime(2000, 01, 01),
                                          //   lastDate: DateTime.now(),
                                          // ).then((value) => selectedDate(value)),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 16.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  logic.dateController.text
                                                          .isNotEmpty
                                                      ? logic
                                                          .dateController.text
                                                      : 'Please Select Delivery Date'
                                                          .tr,
                                                  style: TextStyle(
                                                      color: Color(0xffBCA37F)),
                                                ),
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        GestureDetector(
                                          onTap: () => showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((value) => selectedTime(value)
                                              ?.format(context)),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0,
                                                vertical: 16.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  selectedTime.value != null
                                                      ? AppUtils.selectedTime(
                                                          selectedTime.value!)
                                                      : 'Pick Time'.tr,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: selectedTime.value !=
                                                            null
                                                        ? Colors.black
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.access_time,
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        SizedBox(
                                          height: 60,
                                          // Fixed height for the TextField
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            // Padding for horizontal spacing
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                            ),
                                            child: TextField(
                                              controller: descriptionController,
                                              focusNode: descriptionFocusNode,
                                              decoration: InputDecoration(
                                                hintText: 'Add Description'.tr,
                                                hintStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontFamily: 'RadioCanada',
                                                  fontWeight: FontWeight.w400,
                                                  color: textBrownColor,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                            18.0), // Centers hint text vertically
                                              ),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontFamily: 'RadioCanada',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                              // Aligns input text to start
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              // Vertically centers the input text
                                              onEditingComplete: () {
                                                descriptionFocusNode
                                                    .unfocus(); // Close focus when editing is complete
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        SizedBox(
                                          height: 60,
                                          // Fixed height for the TextField
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            // Padding for horizontal spacing
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                            ),
                                            child: TextField(
                                              controller: priceController,
                                              focusNode: priceNode,
                                              decoration: InputDecoration(
                                                hintText: 'Add Price'.tr,
                                                hintStyle: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontFamily: 'RadioCanada',
                                                  fontWeight: FontWeight.w400,
                                                  color: textBrownColor,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                            18.0), // Centers hint text vertically
                                              ),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontFamily: 'RadioCanada',
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                              textAlign: TextAlign.start,
                                              // Aligns input text to start
                                              textAlignVertical:
                                                  TextAlignVertical.center,
                                              // Vertically centers the input text
                                              onEditingComplete: () {
                                                priceNode
                                                    .unfocus(); // Close focus when editing is complete
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        CustomButton(
                                          buttonText: 'Submit'.tr,
                                          onPress: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (logic.dateController.text
                                                  .isEmpty) {
                                                Get.snackbar('Alert'.tr,
                                                    'Please Select Date'.tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else if (selectedTime.value ==
                                                  null) {
                                                Get.snackbar('Alert'.tr,
                                                    'Please Select Time'.tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else if (logic
                                                      .selectedCityFromId ==
                                                  '-1') {
                                                Get.snackbar(
                                                    'Alert'.tr,
                                                    'Please Select City (From:)'
                                                        .tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else if (logic
                                                      .selectedCityToId ==
                                                  '-1') {
                                                Get.snackbar(
                                                    'Alert'.tr,
                                                    'Please Select City (To:)'
                                                        .tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else if (descriptionController
                                                  .text.isEmpty) {
                                                Get.snackbar(
                                                    'Alert'.tr,
                                                    'Please Enter Description'
                                                        .tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else if (priceController
                                                  .text.isEmpty) {
                                                Get.snackbar('Alert'.tr,
                                                    'Please Enter Price'.tr,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              } else {
                                                await Get.find<UserContorller>()
                                                    .addDriverTrip(
                                                        description:
                                                            descriptionController
                                                                .text,
                                                        price: priceController
                                                            .text,
                                                        from: logic
                                                            .selectedCityFromId,
                                                        to: logic
                                                            .selectedCityToId,
                                                        time: AppUtils
                                                            .selectedTime(
                                                                selectedTime
                                                                    .value!),
                                                        date: logic
                                                            .dateController
                                                            .text);
                                              }
                                            }
                                            return;
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}

class CustomPopup extends StatefulWidget {
  final List<MDCities> mdCities; // List of cities passed from logic.mdCities
  final String hint; // Hint for the dropdown
  final ValueChanged<String?> onValueChanged; // Callback for value change

  CustomPopup({
    required this.mdCities,
    required this.onValueChanged,
    required this.hint,
  });

  @override
  _CustomPopupState createState() => _CustomPopupState();
}

class _CustomPopupState extends State<CustomPopup> {
  RxString selectedValue = ''.obs;
  String searchQuery = '';
  bool showNoMatchesMessage = false;

  // Filtered list based on the search query
  List<MDCities> filteredCities = [];

  @override
  void initState() {
    super.initState();
    filteredCities = widget.mdCities; // Initially show all cities
  }

  @override
  void didUpdateWidget(CustomPopup oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.mdCities != widget.mdCities) {
      // If cities list has changed, reset the filteredCities to the new list
      setState(() {
        filteredCities = widget.mdCities;
      });
    }
  }

  filterCities(String query) {
    setState(() {
      searchQuery = query;

      // Filter the cities based on the search query
      filteredCities = widget.mdCities
          .where((city) =>
              city.cityName != null &&
              city.cityName!.toLowerCase().startsWith(query.toLowerCase()))
          .toList();

      // If no matches are found, show the "No Matched Items" message
      showNoMatchesMessage = filteredCities.isEmpty && query.isNotEmpty;
    });

    // If no matches, reset after 2 seconds
    if (showNoMatchesMessage) {
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            // Clear the search query and reset the filtered cities
            searchQuery = '';
            filteredCities = widget.mdCities; // Reset to all cities
            showNoMatchesMessage = false; // Hide the "No Matched Items" message
          });
        }
      });
    }
  }

  void _showCityDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height -
                200, // Set the full height minus 200
            width: MediaQuery.of(context).size.width -
                20, // Set the width minus 20
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onChanged: (query) {
                          filterCities(query);
                          setState(() {}); // Trigger the dialog state update
                        },
                      );
                    },
                  ),
                ),
                if (showNoMatchesMessage)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: Text(
                        "No Matched Items",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                Expanded(
                  child: StatefulBuilder(
                    builder: (BuildContext context, setState) {
                      return ListView(
                        children: filteredCities.map((city) {
                          return ListTile(
                            title: Text(city.cityName!),
                            onTap: () {
                              setState(() {
                                selectedValue.value = city.cityName!;
                              });
                              widget.onValueChanged(city.cityName);
                              Navigator.of(context)
                                  .pop(); // Close the dialog after selecting
                            },
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showCityDialog, // Show the popup when clicked
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 1.0),
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          child: Row(
            children: [
              // Wrap the Text widget in an Expanded or Flexible widget
              Expanded(
                child: Container(
                  // color: Colors.black,
                  child: Obx(
                    () {
                      String displayValue = selectedValue.value.isNotEmpty
                          ? selectedValue.value
                          : widget.hint;
                      return Text(
                        displayValue,
                        overflow: TextOverflow.ellipsis,
                        // Ensure long text doesn't overflow
                        maxLines: 2,
                        // Ensure only one line of text is shown
                        style: TextStyle(
                          fontSize:  14.0,
                          // Reduce font size if text length is more than 6
                          fontFamily: 'RadioCanada',
                          fontWeight: FontWeight.w400,
                          color: Colors.brown,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: Colors.brown),
            ],
          ),
        ),
      ),
    );
  }
}
