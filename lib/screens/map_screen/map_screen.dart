import 'dart:async';

import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _googelMapController = Completer();
  final String google_api_key = 'AIzaSyADe4ap_GP1t90-1oWzOF-65rATryBiXQo';
  static const _sourceLocation = LatLng(11.5683, 104.8908);
  static const _directionLocation = LatLng(11.5885, 104.9302);

  final BitmapDescriptor _sourceIcon = BitmapDescriptor.defaultMarker;
  final BitmapDescriptor _locatoinIcon = BitmapDescriptor.defaultMarker;
  final BitmapDescriptor _currentIcon = BitmapDescriptor.defaultMarker;
  LocationData? _currentLocation;

  void _setCustomeIcon() async {
    // _currentIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, AssetsConst.CAMBODAI_FLAG);
  }

  void _getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((value) {
      _currentLocation = value;
    }).whenComplete(() {
      setState(() {});
    });

    GoogleMapController googleMapController = await _googelMapController.future;

    location.onLocationChanged.listen((newLocation) {
      setState(() {
        _currentLocation = newLocation;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 14.5,
              target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
            ),
          ),
        );
      });
    });
  }

  final List<LatLng> _polyLineCodinate = [];

  void _getPolyPoint() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult polylineResult = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key,
      PointLatLng(_sourceLocation.latitude, _sourceLocation.longitude),
      PointLatLng(_directionLocation.latitude, _directionLocation.longitude),
    );

    if (polylineResult.points.isNotEmpty) {
      for (var pointLatLng in polylineResult.points) {
        _polyLineCodinate.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _setCustomeIcon();
    _getCurrentLocation();
    _getPolyPoint();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('map')),
        ),
        body: _currentLocation == null
            ? const Center(
                child: Text('Loading'),
              )
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        zoom: 14.5,
      ),
      markers: {
        const Marker(
          markerId: MarkerId('soruce'),
          position: _sourceLocation,
        ),
        const Marker(
          markerId: MarkerId('destination'),
          position: _directionLocation,
        ),
        Marker(
          icon: _currentIcon,
          markerId: const MarkerId('currentLocatoin'),
          position: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
        ),
      },
      polylines: {
        Polyline(
          polylineId: const PolylineId("route"),
          points: _polyLineCodinate,
          color: Colors.blue,
          width: 6,
        )
      },
      onMapCreated: (controller) {
        _googelMapController.complete(controller);
      },
    );
  }
}
