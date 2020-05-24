import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _pusatMedan = CameraPosition(
    target: LatLng(3.591384, 98.677371),
    zoom: 15,
  );

  void _requestLocationAccess() async {
    var isUndeterminedBefore = await Permission.location.isUndetermined;

    if (!await Permission.location.request().isGranted) {
      Fluttertoast.showToast(
          msg:
              "Anda dapat mengijinkan akses lokasi agar dapat melihat cctv terdekat dengan Anda.");
    } else {
      if (isUndeterminedBefore) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _requestLocationAccess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _pusatMedan,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
