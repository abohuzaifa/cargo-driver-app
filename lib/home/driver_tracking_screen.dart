import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constant/colors_utils.dart';

import 'package:flutter/material.dart';

class FindTripOnline extends StatefulWidget {
  const FindTripOnline({super.key});

  @override
  State<FindTripOnline> createState() => _FindTripOnlineState();
}

class _FindTripOnlineState extends State<FindTripOnline> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,
          title: const Text('Find Your Trip'),
          actions: const [Icon(Icons.search)],
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomRight,
                      colors: [bgColor, bgColor.withOpacity(0.01)])),
              child: const GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: LatLng(31.2233, 71.566))),
            ))
          ],
        ));
  }
}
