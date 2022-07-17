import 'dart:async';

import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final String phone, name;

  final LatLng direction;
  const MapScreen({Key? key, required this.name, required this.phone, required this.direction}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _googelMapController = Completer();
  final String google_api_key = 'AIzaSyADe4ap_GP1t90-1oWzOF-65rATryBiXQo';
  static const _sourceLocation = LatLng(11.574346190818169, 104.90369256331002);
  late var _directionLocation;

  final BitmapDescriptor _sourceIcon = BitmapDescriptor.defaultMarker;
  final BitmapDescriptor _locatoinIcon = BitmapDescriptor.defaultMarker;
  final BitmapDescriptor _currentIcon = BitmapDescriptor.defaultMarker;
  LocationData? _currentLocation;

  void _setCustomeIcon() async {
    // _currentIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/images/car');
  }

  void _getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((value) {
      _currentLocation = value;
    }).whenComplete(() {
      if (mounted) {
        setState(() {});
      }
    });

    GoogleMapController googleMapController = await _googelMapController.future;

    location.onLocationChanged.listen((newLocation) {
      if (mounted) {
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
      }
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
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _directionLocation = widget.direction;
    _setCustomeIcon();
    _getCurrentLocation();
    _getPolyPoint();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: ColorsConts.primaryColor),
          backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
          foregroundColor: ColorsConts.primaryColor,
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
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(children: [
            Text(I18NTranslations.of(context).text('user_name') + '\t' + widget.name, maxLines: 2),
            Text(
              I18NTranslations.of(context).text('phone_number') + '\t' + widget.phone,
              maxLines: 2,
            ),
          ]),
        ),
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
              zoom: 14.5,
            ),
            markers: {
              const Marker(
                markerId: MarkerId('soruce'),
                position: _sourceLocation,
              ),
              Marker(
                markerId: const MarkerId('destination'),
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
          ),
        ),
      ],
    );
  }
}
