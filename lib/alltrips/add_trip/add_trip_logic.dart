import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../models/user_model.dart';
import 'add_trip_model.dart';

class AddTripController extends GetxController {
  List<MDCities> mdCities = [];
  RxBool isLoading = false.obs;
  String selectedCityFromId='-1';
  String selectedCityToId='-1';

  String? fromValue;
  String? toValue;
  DateTime? _selectedDate;
  final TextEditingController dateController = TextEditingController();

  final selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    init();
  }

  init() async {
    isLoading.value = true;
    await getAllCities();
    isLoading.value = false;
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CalendarDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
            onDateChanged: (DateTime picked) {
              // Automatically set the selected date and update the controller
              _selectedDate = picked;
              dateController.text = "${picked.toLocal()}".split(' ')[0];

              // Format the date and update the controller
              String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
              dateController.text = formattedDate;              update();
              Navigator.pop(
                  context); // Close the dialog after selecting the date
              print('dateController=====${dateController.text}');
            },
          ),
        );
      },
    );
  }


  Future<List> getAllCities() async {
    final url = Uri.parse('https://thardi.com/api/cities');
    HttpOverrides.global = MyHttpOverrides();

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        "Authorization": "Bearer${UserModel().token}"
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('This is jsonResponse in getAllCities=========${jsonResponse}');
      if (jsonResponse is List) {
        mdCities = jsonResponse
            .map((city) => MDCities.fromJson(city as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Expected a list but got something else');
      }
      update();
      return jsonResponse;
    } else {
      throw Exception('Failed to load getAllCities');
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
