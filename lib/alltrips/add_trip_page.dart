import 'package:cargo_driver_app/constant/colors_utils.dart';
import 'package:cargo_driver_app/home/controller/user_controler.dart';
import 'package:cargo_driver_app/util/apputils.dart';
import 'package:cargo_driver_app/widgets/back_button_widget.dart';
import 'package:cargo_driver_app/widgets/custom_button.dart';
import 'package:cargo_driver_app/widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddTripPage extends StatelessWidget {
  AddTripPage({super.key});
  final _fromCity = TextEditingController(), _toCity = TextEditingController();
  final selectedTime = Rx<TimeOfDay?>(null);
  final selectedDate = Rx<DateTime?>(null);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
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
              buildBackButton(context, isAction: true, onTap: Get.back),
              SizedBox(
                height: 50.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.h),
                child: const Text('Add Your Trip'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 40.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        validator: (p0) {
                          if (p0!.isEmpty || p0.length < 3) {
                            return 'Enter valid city';
                          }
                          return null;
                        },
                        controller: _fromCity,
                        hintText: 'From',
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomTextField(
                        validator: (p0) {
                          if (p0!.isEmpty || p0.length < 3) {
                            return 'Enter valid city';
                          }
                          return null;
                        },
                        controller: _toCity,
                        hintText: 'To',
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Pick Date';
                          }
                          return null;
                        },
                        onTap: () => showDatePicker(
                                context: context,
                                firstDate: DateTime(2000, 01, 01),
                                lastDate: DateTime.now())
                            .then((value) => selectedDate(value)),
                        controller: TextEditingController(
                            text: selectedDate.value != null
                                ? AppUtils.selectedDate(selectedDate.value!)
                                : 'Pick Date'),
                        hintText: 'Pick Date',
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomTextField(
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return 'Pick Time';
                          }
                          return null;
                        },
                        onTap: () => showTimePicker(
                                context: context, initialTime: TimeOfDay.now())
                            .then((value) =>
                                selectedTime(value)?.format(context)),
                        controller: TextEditingController(
                            text: selectedTime.value != null
                                ? AppUtils.selectedTime(selectedTime.value!)
                                : 'Pick Time'),
                        hintText: 'Pick Time',
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      CustomButton(
                        buttonText: 'Submit',
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            await Get.find<UserContorller>().addDriverTrip(
                                from: _fromCity.text,
                                to: _toCity.text,
                                time:
                                    AppUtils.selectedTime(selectedTime.value!),
                                date:
                                    AppUtils.selectedDate(selectedDate.value!));
                          }
                          return;
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
