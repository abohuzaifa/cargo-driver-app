// ignore_for_file: library_prefixes

import 'dart:developer';
import 'dart:io';
import 'package:cargo_driver_app/models/user_model.dart';
import 'package:dio/dio.dart' as apiClient;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../api/api_constants.dart';
import 'api_loader.dart';
import 'auth_controller.dart';

class APISTRUCTURE {
  final String apiUrl;
  dynamic body;
  final bool isWantSuccessMessage;
  final String apiRequestMethod;
  String? contentType;

  APISTRUCTURE({
    this.body,
    required this.apiUrl,
    required this.apiRequestMethod,
    this.isWantSuccessMessage = false,
    this.contentType,
  });

  Future<Map<String, dynamic>> requestAPI(
      {bool isShowLoading = false, bool isCheckAuthorization = true}) async {
    String api = "";
    if (isShowLoading) {
      ApiLoader.show();
    }
    try {
      api = BASE_URL + apiUrl;
      Map<String, String> header = {};

      if (contentType != null) {
        header.addAll({"Content-Type": contentType!});
        print('Content-Type added: $contentType');
      } else {
        print('No Content-Type specified');
      }

      if (isCheckAuthorization) {
        String? authToken = Get.find<AuthController>().authRepo.getAuthToken();
        print('Auth Token retrieved: ${authToken != null ? "Yes" : "No"}');
        if (authToken != null) {
          header.addAll({
            "Accept": "application/json",
            "Authorization": "Bearer $authToken",
          });
          print('Authorization token added to headers');
        } else {
          print('Authorization token not available');
        }
      } else {
        header.addAll({
          "Accept": "application/json",
        });
        print('Authorization check disabled, only Accept header added');
      }

      print('Final headers: $header');

      apiClient.Dio dio = apiClient.Dio();
      apiClient.Options options = apiClient.Options(
        followRedirects: false,
        headers: header,
        validateStatus: (int? status) => (status ?? 500) < 600,
      );

      apiClient.Response<dynamic> response;
      if (apiRequestMethod == APIREQUESTMETHOD.GET) {
        response = await dio.get(api, options: options);
      } else if (apiRequestMethod == APIREQUESTMETHOD.POST) {
        response = await dio.post(api, data: body, options: options);
      } else if (apiRequestMethod == APIREQUESTMETHOD.DELETE) {
        response = await dio.delete(api, options: options);
      } else {
        response = await dio.put(api, data: body, options: options);
      }

      log('$api response:[${response.statusCode}]----> $response');

      if (isShowLoading) {
        ApiLoader.hide();
      }

      if (response.statusCode == 200) {
        return {APIRESPONSE.SUCCESS: response.data};
      }

      Map<String, dynamic> responseResult = response.statusCode != null
          ? response.data
          : {APIRESPONSE.ERROR: "Something went wrong"};

      return responseResult;
    } on SocketException {
      _handleException(isShowLoading, "Internet Connection Error");
      return {APIRESPONSE.EXCEPTION: APIEXCEPTION.SOCKET};
    } on HttpException {
      _handleException(isShowLoading, "Internet Connection Error");
      return {APIRESPONSE.EXCEPTION: APIEXCEPTION.HTTP};
    } on FormatException {
      _handleException(isShowLoading, "Server Bad response");
      return {APIRESPONSE.EXCEPTION: APIEXCEPTION.FORMAT};
    } on apiClient.DioException catch (e) {
      if (isShowLoading) {
        ApiLoader.hide();
      }
      String errorMessage = _getDioErrorMessage(e);
      _showErrorDialog(errorMessage);
      return {APIRESPONSE.EXCEPTION: errorMessage};
    } catch (error) {
      if (isShowLoading) {
        ApiLoader.hide();
      }
      String errorMessage = error.toString().contains("SocketException")
          ? "Internet Connection Error"
          : error.toString();
      _showErrorDialog(errorMessage);
      return {APIRESPONSE.EXCEPTION: errorMessage};
    }
  }

  void _handleException(bool isShowLoading, String message) {
    if (isShowLoading) {
      ApiLoader.hide();
    }
    _showErrorDialog(message);
  }

  void _showErrorDialog(String message) {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) => CupertinoAlertDialog(
        actions: [
          CupertinoDialogAction(
            onPressed: () => Get.back(),
            child: const Text('Ok'),
          ),
        ],
        content: Text(message),
      ),
    );
  }

  String _getDioErrorMessage(apiClient.DioException e) {
    switch (e.type) {
      case apiClient.DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case apiClient.DioExceptionType.sendTimeout:
        return "Sent timeout";
      case apiClient.DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case apiClient.DioExceptionType.connectionError:
        return "Server error";
      case apiClient.DioExceptionType.badCertificate:
        return "Server Certificate Error";
      case apiClient.DioExceptionType.badResponse:
        return "Bad Request";
      case apiClient.DioExceptionType.unknown:
        return "Server Unknown Error";
      case apiClient.DioExceptionType.cancel:
        return "Request cancelled";
      default:
        return "Unexpected error";
    }
  }
}
