import 'dart:async';

import 'package:cctv_medan/models/Cctv.dart';
import 'package:cctv_medan/player.dart';
import 'package:cctv_medan/providers/CctvState.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor _markerIconToUse;

  List<Cctv> listCctv;

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

    _scrollToCurrentPosition();

    Future.delayed(Duration(milliseconds: 100), () {
      final cctvState = Provider.of<CctvState>(context);
      cctvState.fetchCctvData();
    });
  }

  void _scrollToCurrentPosition() {
    // create an instance of Location
    var location = new Location();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.first.then((locationData) async {
      final controller = await _controller.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locationData.latitude, locationData.longitude),
            zoom: _pusatMedan.zoom,
          ),
        ),
      );
    });
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIconToUse == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/img/marker.png')
          .then((bitmap) {
        setState(() {
          _markerIconToUse = bitmap;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cctvState = Provider.of<CctvState>(context);

    _createMarkerImageFromAsset(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.help_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("CCTV Kota Medan"),
                content: Text(
                    "Aplikasi ini dibangun agar masyarakat yang memiliki waktu luang (seperti saya) dapat memantau arus lalu lintas di seputaran Kota Medan.\n\nLive streaming yang terdapat di aplikasi ini sepenunhnya merupakan milik ATCS Kota Medan.\n\n\n- Built with <3 with Flutter\nCharlie"),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Oke sip!"),
                  ),
                ],
              ),
            );
          },
        ),
        title: Text('CCTV Kota Medan', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _pusatMedan,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: cctvState.listCctv
            .map(
              (cctv) => Marker(
                markerId: MarkerId(cctv.toMarkerIdName()),
                position: LatLng(cctv.lat, cctv.lng),
                consumeTapEvents: true,
                icon: _markerIconToUse,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(
                        title: cctv.name,
                        url: cctv.url,
                      ),
                    ),
                  );
                },
              ),
            )
            .toSet(),
      ),
    );
  }
}
