import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cargo_driver_app/home/controller/ridetrcaking_controller.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart';

sealed class MQTTClient {
  // ignore: constant_identifier_names
  static const String _MQTT_BASE_URL = "mqtt-dashboard.com";
  static late final MqttServerClient client;

  static void _onConnected() {
    log('Connected to MQTT broker');
  }

  static void _onDisconnected() {
    log('Disconnected from MQTT broker');
  }

  static void _onSubscribed(String topic) {
    log('Subscription confirmed for topic $topic');
  }

  static void _onSubscribeFail(String topic) {
    log('Failed to subscribe to topic $topic');
  }

  static void _onUnsubscribed(String? topic) {
    log('Unsubscribed from topic $topic');
  }

  static Future<void> mqttForUser(String driverId) async {
    final clientId =
        'DRIVER-APP-${driverId}_${DateTime.now().millisecondsSinceEpoch}';
    client = MqttServerClient.withPort(
      _MQTT_BASE_URL,
      clientId,
      1883,
    );

    client.setProtocolV311();
    client.logging(on: true);
    client.keepAlivePeriod = 120;
    client.autoReconnect = true;

    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    client.onUnsubscribed = _onUnsubscribed;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      log('No connection: ${e.toString()}');
      return;
    } on SocketException catch (e) {
      log('Socket error: ${e.toString()}');
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      log('MQTT client connected');
    } else {
      log('MQTT client connection failed - disconnecting, state is ${client.connectionStatus?.state}');
      client.disconnect();
      return;
    }

    client.subscribe('ride_request_status_$driverId', MqttQos.atLeastOnce);
    client.subscribe("ride_user_request_$driverId", MqttQos.atLeastOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final MqttPublishMessage recMess = c![0].payload as MqttPublishMessage;
      final MqttReceivedMessage<MqttMessage?> message = c[0];
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      try {
        // Process the received message based on your application's logic
        if (message.topic == 'ride_user_request_$driverId') {
          final rideStatus = RideStatusModel.fromJson(jsonDecode(payload));
          if (rideStatus.userLocation != null) {
            Get.find<RideTrackingController>().userLatitude.value =
                rideStatus.userLocation!.latitude;
            Get.find<RideTrackingController>().userLongitude.value =
                rideStatus.userLocation!.latitude;
          }
          final Map<String, dynamic> decodedPayload = jsonDecode(payload);
          log(' payload of ride_user_request: $decodedPayload');
        } else if (message.topic == 'ride_request_status_$driverId') {
          final Map<String, dynamic> decodedPayload = jsonDecode(payload);
          log(' payload ride_request_status: $decodedPayload');
        }
      } catch (e) {
        log('Error decoding payload: $e');
      }
    });
  }

  static void emitLocation(LocationModel location, String driverId) {
    log('Emitting message for driver: $driverId, coordinates: ${location.toString()}');
    final message = RideStatusModel(
      userLocation: null,
      driverLocation: location,
      status: 'Accepted',
    ).toJson().convertMapToUint8Buffer;

    client.publishMessage(
      'ride_request_status_$driverId',
      MqttQos.atLeastOnce,
      message,
    );
  }
}

class RideStatusModel {
  RideStatusModel({
    this.status = 'Accepted',
    this.userLocation,
    this.driverLocation,
  });

  final String status;
  final LocationModel? userLocation;
  final LocationModel? driverLocation;

  factory RideStatusModel.fromJson(Map<String, dynamic> json) {
    final userLocation = json['user_location'];
    final driverLocation = json['driver_location'];
    return RideStatusModel(
      userLocation:
          userLocation == null ? null : LocationModel.fromJson(userLocation),
      driverLocation: driverLocation == null
          ? null
          : LocationModel.fromJson(driverLocation),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_status': status,
      'user_location': userLocation?.toJson(),
      'driver_location': driverLocation?.toJson(),
    };
  }
}

class LocationModel {
  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude)';
  }
}

extension _MapParseExtension on Map<String, dynamic> {
  Uint8Buffer get convertMapToUint8Buffer {
    final jsonString = jsonEncode(this);
    final byteList = utf8.encode(jsonString);
    final uint8buffer = Uint8Buffer();
    uint8buffer.addAll(byteList);
    return uint8buffer;
  }
}
