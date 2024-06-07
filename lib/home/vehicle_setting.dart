import 'package:cargo_driver_app/home/controller/user_controler.dart';
import '../../constant/colors_utils.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../widgets/custom_button.dart';

class VehicleSettingPage extends StatelessWidget {
  VehicleSettingPage({super.key});
  final _formKey = GlobalKey<FormState>();
  final _plateNumber = TextEditingController(),
      _licence = TextEditingController();
  final selectedType = Rx<String>('');
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.center,
            colors: [
              bgColor,
              bgColor.withOpacity(0.1),
              bgColor.withOpacity(0.1)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.all(20.0.h),
              child: InkWell(
                onTap: Get.back,
                child: const Icon(
                  Icons.arrow_back_ios_new_sharp,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Center(
              child: Text(
                'Vehicle Setting',
                style: TextStyle(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                    color: textcyanColor),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.all(20.0.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                top: 16.0, left: 15, right: 15),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(13)),
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(13)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(13)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(13))),
                        hint: const Text('Vehicle Type'),
                        value: null,
                        items: ['Car', 'Bike', 'Truk']
                            .map((e) => DropdownMenuItem<String>(
                                value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          selectedType(v);
                        }),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      validator: (p0) {
                        if (p0!.isEmpty || p0.length < 7) {
                          return 'Enter valid number plate';
                        }
                        return null;
                      },
                      maxLines: 1,
                      hintText: 'Number Plate',
                      controller: TextEditingController(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomTextField(
                      validator: (p0) {
                        if (p0!.isEmpty || p0.length < 11) {
                          return 'Enter valid licence Number';
                        }
                        return null;
                      },
                      maxLines: 1,
                      hintText: 'Driving License',
                      controller: TextEditingController(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                        buttonText: "Upate",
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            Get.find<UserContorller>().updateVehicleInfo(
                                plateNumber: _plateNumber.text.trim(),
                                vehicleTyep: selectedType.value,
                                drivingLicence: _licence.text.trim());
                          }
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
