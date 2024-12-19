import 'dart:developer';

import 'package:cargo_driver_app/api/auth_controller.dart';
import 'package:cargo_driver_app/widgets/contact_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../auth_screen/login_screen.dart';
import '../../constant/colors_utils.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});
//
//   final _nameController = TextEditingController(),
//       _passwordController = TextEditingController(),
//       _phoneController = TextEditingController(),
//       _emailController = TextEditingController(),
//       _confirmPasswordController = TextEditingController(),
//       _addressController = TextEditingController(),
//       _drivingLicenseController = TextEditingController(),
//       _accountController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   final _code = Rx<String>('+996');
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 colors: [bgColor, bgColor.withOpacity(0.01)])),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(height: 30.h),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         color: lightBrownColor,
//                       ),
//                     )
//                   ],
//                 ),
//                 SizedBox(height: 10.h),
//                 Text(
//                   "Sign Up".tr,
//                   style: TextStyle(
//                       fontSize: 32.sp,
//                       fontWeight: FontWeight.bold,
//                       color: textcyanColor),
//                 ),
//                 SizedBox(height: 90.h),
//                 Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         CustomTextField(
//                           validator: (p0) {
//                             if (p0!.isEmpty || p0.length < 3) {
//                               return 'Enter valid name'.tr;
//                             }
//                             return null;
//                           },
//                           controller: _nameController,
//                           maxLines: 1,
//                           hintText: "Full Name".tr,
//                         ),
//                         SizedBox(height: 20.h),
//                         InkWell(
//                           onTap: () async {
//                             LatLng? pickedLocation =
//                                 await Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => PlacePickerMapScreen(),
//                               ),
//                             );
//                             print('pickedLocation====${pickedLocation}');
//                             // String? city =
//                             // await _extractCityFor(pickedLocation);
//                             // print('city In Parcel====${city}');
//                             // if (city != null) {
//                             //   parcelCity.value = city;
//                             //   _parcelLat.value =
//                             //       pickedLocation!.latitude.toString();
//                             //   _parcelLan.value =
//                             //       pickedLocation.longitude.toString();
//                             //   print(
//                             //       '_parcelLat.value====${_parcelLat.value}');
//                             //   print(
//                             //       '_parcelLan.value ====${_parcelLan.value}');
//                             // }
//                             // if (pickedLocation != null) {
//                             //   _getAddressFromLatLngForParcelAddress(
//                             //       pickedLocation);
//                             // }
//                           },
//                           child: Container(
//                             width: MediaQuery.of(context).size.width,
//                             padding: EdgeInsets.all(12.0),
//                             // margin: EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                 color: Colors.white,
//                                 width: 1.0,
//                               ),
//                               borderRadius: BorderRadius.circular(13.0),
//                             ),
//                             child: Text(
//                              'Select your Location'.tr,
//                               style: TextStyle(
//                                   fontSize: 16.sp,
//                                   fontFamily: 'RadioCanada',
//                                   fontWeight: FontWeight.w400,
//                                   color: textBrownColor),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(height: 20.h),
//                         DropdownButtonFormField<String>(
//                             icon:
//                                 const Icon(Icons.keyboard_arrow_down_outlined),
//                             decoration: InputDecoration(
//                                 contentPadding: const EdgeInsets.only(
//                                     top: 16.0, left: 15, right: 15),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 border: InputBorder.none,
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(13)),
//                                 disabledBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(13)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(13)),
//                                 errorBorder: OutlineInputBorder(
//                                   borderSide: BorderSide.none,
//                                   borderRadius: BorderRadius.circular(13),
//                                 ),
//                                 focusedErrorBorder: OutlineInputBorder(
//                                     borderSide: BorderSide.none,
//                                     borderRadius: BorderRadius.circular(13))),
//                             hint: Text('Vehicle Type'.tr),
//                             value: null,
//                             items: ['Car', 'Truck']
//                                 .map((e) => DropdownMenuItem<String>(
//                                     value: e, child: Text(e)))
//                                 .toList(),
//                             onChanged: (v) {}),
//                         SizedBox(height: 20.h),
//                         // CustomTextField(
//                         //   validator: (p0) {
//                         //     if (p0!.isEmpty || p0.length < 6) {
//                         //       return 'Enter valid license';
//                         //     }
//                         //     return null;
//                         //   },
//                         //   controller: _drivingLicenseController,
//                         //   maxLines: 1,
//                         //   hintText: "Driving License",
//                         // ),
//                         // SizedBox(height: 20.h),
//                         // DropdownButtonFormField<String>(
//                         //     icon:
//                         //         const Icon(Icons.keyboard_arrow_down_outlined),
//                         //     decoration: InputDecoration(
//                         //         contentPadding: const EdgeInsets.only(
//                         //             top: 16.0, left: 15, right: 15),
//                         //         filled: true,
//                         //         fillColor: Colors.white,
//                         //         border: InputBorder.none,
//                         //         enabledBorder: OutlineInputBorder(
//                         //             borderSide: BorderSide.none,
//                         //             borderRadius: BorderRadius.circular(13)),
//                         //         disabledBorder: OutlineInputBorder(
//                         //             borderSide: BorderSide.none,
//                         //             borderRadius: BorderRadius.circular(13)),
//                         //         focusedBorder: OutlineInputBorder(
//                         //             borderSide: BorderSide.none,
//                         //             borderRadius: BorderRadius.circular(13)),
//                         //         errorBorder: OutlineInputBorder(
//                         //           borderSide: BorderSide.none,
//                         //           borderRadius: BorderRadius.circular(13),
//                         //         ),
//                         //         focusedErrorBorder: OutlineInputBorder(
//                         //             borderSide: BorderSide.none,
//                         //             borderRadius: BorderRadius.circular(13))),
//                         //     hint: const Text('Select Bank'),
//                         //     value: null,
//                         //     items: ['Samba', 'AlSaud', 'National']
//                         //         .map((e) => DropdownMenuItem<String>(
//                         //             value: e, child: Text(e)))
//                         //         .toList(),
//                         //     onChanged: (v) {}),
//                         SizedBox(height: 20.h),
//                         CustomTextField(
//                           validator: (p0) {
//                             if (p0!.isEmpty || p0.length < 10) {
//                               return 'Enter IBAN'.tr;
//                             }
//                             return null;
//                           },
//                           controller: _accountController,
//                           maxLines: 1,
//                           hintText: "IBAN".tr,
//                         ),
//                         SizedBox(height: 20.h),
//                         ContactField(
//                           onChanged: (p0) {
//                             _code(p0.toString());
//                             log(_code.toString());
//                           },
//                           validator: (p0) {
//                             if (p0!.isEmpty || p0.length < 9) {
//                               return 'Enter valid phone without country code'
//                                   .tr;
//                             }
//                             return null;
//                           },
//                           controller: _phoneController,
//                         ),
//                         SizedBox(height: 20.h),
//                         CustomTextField(
//                           validator: (p0) {
//                             if (p0!.isEmpty || !p0.contains('@')) {
//                               return 'Enter valid email'.tr;
//                             }
//                             return null;
//                           },
//                           controller: _emailController,
//                           maxLines: 1,
//                           hintText: "Email".tr,
//                         ),
//                         SizedBox(height: 20.h),
//                         CustomTextField(
//                           validator: (p0) {
//                             if (p0!.isEmpty || p0.length < 6) {
//                               return 'Enter valid password minimum 6 characters'
//                                   .tr;
//                             }
//                             return null;
//                           },
//                           controller: _passwordController,
//                           obscureText: true,
//                           hintText: "Password".tr,
//                           maxLines: 1,
//                         ),
//                         SizedBox(height: 20.h),
//                         CustomTextField(
//                           validator: (p0) {
//                             if (p0!.isEmpty || p0 != _passwordController.text) {
//                               return 'password don\'t match'.tr;
//                             }
//                             return null;
//                           },
//                           controller: _confirmPasswordController,
//                           obscureText: true,
//                           hintText: "Confirm Password".tr,
//                           maxLines: 1,
//                         ),
//                         SizedBox(height: 55.h),
//                         CustomButton(
//                             buttonText: "Next".tr,
//                             onPress: () {
//                               if (_formKey.currentState!.validate()) {
//                                 Get.find<AuthController>().registerUser(
//                                     confirmPass:
//                                         _confirmPasswordController.text,
//                                     drivingLicence:
//                                         _drivingLicenseController.text,
//                                     vehicleType: 1,
//                                     bankAccount: _accountController.text,
//                                     bankId: 2,
//                                     address: _addressController.text,
//                                     fullName: _nameController.text,
//                                     mobileNumber:
//                                         _code.value + _phoneController.text,
//                                     email: _emailController.text,
//                                     password: _passwordController.text);
//                               }
//                             }),
//                       ],
//                     )),
//                 SizedBox(height: 25.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Already Have Account? ".tr,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w500,
//                           color: const Color(0xff113946)),
//                     ),
//                     InkWell(
//                       onTap: () => Get.to(() => LoginScreen()),
//                       child: Text(
//                         "Log In".tr,
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w500,
//                             color: textBrownColor),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode nameNode = FocusNode();
  final FocusNode ibanNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmNode = FocusNode();
  final _nameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _phoneController = TextEditingController(),
      _emailController = TextEditingController(),
      _confirmPasswordController = TextEditingController(),
      _addressController = TextEditingController(),
      _drivingLicenseController = TextEditingController(),
      _ibanController = TextEditingController();
  String? address;
  String? addressLat;
  String? addressLong;
  int? vehicleType;

  final _formKey = GlobalKey<FormState>();
  final _code = Rx<String>('+996');

  Future<void> _getAddressFromLatLngForParcelAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      setState(() {
        address =
            '${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}';
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [bgColor, bgColor.withOpacity(0.01)])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: lightBrownColor,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  "Sign Up".tr,
                  style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: textcyanColor),
                ),
                SizedBox(height: 90.h),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 3) {
                              return 'Enter valid name'.tr;
                            }
                            return null;
                          },
                          controller: _nameController,
                          maxLines: 1,
                          hintText: "Full Name".tr,
                          focusNode: nameNode,
                        ),
                        SizedBox(height: 20.h),
                        InkWell(
                          onTap: () async {
                            nameNode.unfocus();
                            ibanNode.unfocus();
                            phoneNode.unfocus();
                            emailNode.unfocus();
                            passwordNode.unfocus();
                            confirmNode.unfocus();

                            LatLng? pickedLocation =
                                await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PlacePickerMapScreen(),
                              ),
                            );
                            print('pickedLocation====${pickedLocation}');
                            // String? city =
                            // await _extractCityFor(pickedLocation);
                            // print('city In Parcel====${city}');
                            // if (city != null) {
                            //   parcelCity.value = city;
                            //   _parcelLat.value =
                            //       pickedLocation!.latitude.toString();
                            //   _parcelLan.value =
                            //       pickedLocation.longitude.toString();
                            //   print(
                            //       '_parcelLat.value====${_parcelLat.value}');
                            //   print(
                            //       '_parcelLan.value ====${_parcelLan.value}');
                            // }
                            addressLat = pickedLocation!.latitude.toString();
                            addressLong = pickedLocation.longitude.toString();
                            print('addressLat====${addressLat}');
                            print('addressLong====${addressLong}');

                            if (pickedLocation != null) {
                              _getAddressFromLatLngForParcelAddress(
                                  pickedLocation);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.all(12.0),
                            // margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(13.0),
                            ),
                            child: Text(
                              address != null
                                  ? address!
                                  : 'Select your Location'.tr,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontFamily: 'RadioCanada',
                                  fontWeight: FontWeight.w400,
                                  color: textBrownColor),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: 20.h),

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
                                borderRadius: BorderRadius.circular(13)),
                          ),
                          hint: Text('Vehicle Type'.tr),
                          value: null,
                          items: [
                            DropdownMenuItem<String>(
                              value: 'Car',
                              child: Text('Car'),
                            ),
                            DropdownMenuItem<String>(
                              value: 'Truck',
                              child: Text('Truck'),
                            ),
                          ],
                          onChanged: (value) {
                            nameNode.unfocus();
                            ibanNode.unfocus();
                            phoneNode.unfocus();
                            emailNode.unfocus();
                            passwordNode.unfocus();
                            confirmNode.unfocus();
                            if (value == 'Car') {
                              vehicleType = 1;
                            } else if (value == 'Truck') {
                              vehicleType = 2;
                            }
                            print(
                                'Selected Vehicle Type: $vehicleType'); // Debug output
                           },
                        ),

                        SizedBox(height: 20.h),
                        // CustomTextField(
                        //   validator: (p0) {
                        //     if (p0!.isEmpty || p0.length < 6) {
                        //       return 'Enter valid license';
                        //     }
                        //     return null;
                        //   },
                        //   controller: _drivingLicenseController,
                        //   maxLines: 1,
                        //   hintText: "Driving License",
                        // ),
                        // SizedBox(height: 20.h),
                        // DropdownButtonFormField<String>(
                        //     icon:
                        //         const Icon(Icons.keyboard_arrow_down_outlined),
                        //     decoration: InputDecoration(
                        //         contentPadding: const EdgeInsets.only(
                        //             top: 16.0, left: 15, right: 15),
                        //         filled: true,
                        //         fillColor: Colors.white,
                        //         border: InputBorder.none,
                        //         enabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide.none,
                        //             borderRadius: BorderRadius.circular(13)),
                        //         disabledBorder: OutlineInputBorder(
                        //             borderSide: BorderSide.none,
                        //             borderRadius: BorderRadius.circular(13)),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide.none,
                        //             borderRadius: BorderRadius.circular(13)),
                        //         errorBorder: OutlineInputBorder(
                        //           borderSide: BorderSide.none,
                        //           borderRadius: BorderRadius.circular(13),
                        //         ),
                        //         focusedErrorBorder: OutlineInputBorder(
                        //             borderSide: BorderSide.none,
                        //             borderRadius: BorderRadius.circular(13))),
                        //     hint: const Text('Select Bank'),
                        //     value: null,
                        //     items: ['Samba', 'AlSaud', 'National']
                        //         .map((e) => DropdownMenuItem<String>(
                        //             value: e, child: Text(e)))
                        //         .toList(),
                        //     onChanged: (v) {}),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 10) {
                              return 'Enter IBAN'.tr;
                            }
                            return null;
                          },
                          controller: _ibanController,
                          maxLines: 1,
                          hintText: "IBAN".tr,
                        ),
                        SizedBox(height: 20.h),
                        ContactField(
                          onChanged: (p0) {
                            _code(p0.toString());
                            log(_code.toString());
                          },
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 9) {
                              return 'Enter valid phone without country code'
                                  .tr;
                            }
                            return null;
                          },
                          controller: _phoneController,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || !p0.contains('@')) {
                              return 'Enter valid email'.tr;
                            }
                            return null;
                          },
                          controller: _emailController,
                          maxLines: 1,
                          hintText: "Email".tr,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0.length < 6) {
                              return 'Enter valid password minimum 6 characters'
                                  .tr;
                            }
                            return null;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          hintText: "Password".tr,
                          maxLines: 1,
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          validator: (p0) {
                            if (p0!.isEmpty || p0 != _passwordController.text) {
                              return 'password don\'t match'.tr;
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          obscureText: true,
                          hintText: "Confirm Password".tr,
                          maxLines: 1,
                        ),
                        SizedBox(height: 55.h),
                        CustomButton(
                            buttonText: "Next".tr,
                            onPress: () {
                              print('name========${_nameController.text}');
                              print('email=====${_emailController.text}');
                              print(
                                  'mobile_number=====${_code.value + _phoneController.text}');
                              print('password=====${_passwordController.text}');
                              print(
                                  'confirmPassword=====${_confirmPasswordController.text}');
                              print('iban=====${_ibanController.text}');
                              print('addressLat=========${addressLat}');
                              print('addressLong=========${addressLong}');
                              print('address=========${address}');
                              print('vehicleType=========${vehicleType}');
                              print('user_type=========2');

                              if (_formKey.currentState!.validate()) {
                                Get.find<AuthController>().registerUser(
                                    iban: _ibanController.text,
                                    confirmPass:
                                        _confirmPasswordController.text,
                                    vehicleType: vehicleType!,
                                    fullName: _nameController.text,
                                    mobileNumber:
                                        _code.value + _phoneController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    address: address!,
                                    addressLat: addressLat!,
                                    addressLong: addressLong!);
                              }
                            }),
                      ],
                    )),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already Have Account? ".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff113946)),
                    ),
                    InkWell(
                      onTap: () => Get.to(() => LoginScreen()),
                      child: Text(
                        "Log In".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: textBrownColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PlacePickerMapScreen extends StatefulWidget {
  @override
  _PlacePickerMapScreenState createState() => _PlacePickerMapScreenState();
}

class _PlacePickerMapScreenState extends State<PlacePickerMapScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _pickedLocation = _currentLocation;
    });
  }

  void _zoomIn() {
    _mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    _mapController?.animateCamera(CameraUpdate.zoomOut());
  }

  void _goToCurrentLocation() {
    if (_currentLocation != null) {
      _mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation!, zoom: 14),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: _currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Google Map
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentLocation!,
                    zoom: 14,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onCameraMove: (position) {
                    setState(() {
                      _pickedLocation = position.target;
                    });
                  },
                  // Disable default controls
                  myLocationButtonEnabled: false,
                  // Disable the default location button
                  myLocationEnabled: false,
                  // Disable the default location layer
                  zoomControlsEnabled: false,
                  // Disable zoom controls
                  compassEnabled: false, // Disable the compass
                ),

                // Custom Pin in the center of the map
                Center(
                  child: Image.asset(
                    'assets/images/locationIcon.png',
                    height: 75,
                    width: 75,
                    color: Colors.red,
                  ),
                ),

                // Zoom-in Button
                Positioned(
                  bottom: 100,
                  right: 20,
                  child: Column(
                    children: [
                      // Zoom In
                      FloatingActionButton(
                        heroTag: "zoomIn",
                        onPressed: _zoomIn,
                        mini: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.add, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      // Zoom Out
                      FloatingActionButton(
                        heroTag: "zoomOut",
                        onPressed: _zoomOut,
                        mini: true,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.remove, color: Colors.black),
                      ),
                    ],
                  ),
                ),

                // Back to Current Location Button
                Positioned(
                  bottom: 100,
                  left: 20,
                  child: FloatingActionButton(
                    heroTag: "currentLocation",
                    onPressed: _goToCurrentLocation,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.my_location, color: Colors.black),
                  ),
                ),

                // Confirmation button at the bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffBCA37F),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_pickedLocation != null) {
                        Navigator.of(context).pop(_pickedLocation);
                      }
                    },
                    child: Text(
                      'Confirm Location',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
