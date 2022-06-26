import 'dart:async';

import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/i18n/i18n_translate.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class UserMapScreen extends StatefulWidget {
  const UserMapScreen({Key? key}) : super(key: key);

  @override
  State<UserMapScreen> createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  double? _latitude, _longitude;
  final Completer<GoogleMapController> _googelMapController = Completer();

  void _getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((value) {
      _latitude = value.latitude!;
      _longitude = value.longitude!;
      Future.delayed(Duration.zero, () async {
        GoogleMapController googleMapController = await _googelMapController.future;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 14.5,
              target: LatLng(_latitude!, _longitude!),
            ),
          ),
        );
      });
    }).whenComplete(() {
      setState(() {});
    });
  }

  void _onTap(LatLng latLng) {
    _latitude = latLng.latitude;
    _longitude = latLng.longitude;
    Future.delayed(Duration.zero).whenComplete(() async {
      GoogleMapController googleMapController = await _googelMapController.future;
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 14.5,
            target: LatLng(_latitude!, _longitude!),
          ),
        ),
      );
    });

    setState(() {});
  }

  @override
  void initState() {
    _getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _getCurrentLocation();
          },
          label: Text(I18NTranslations.of(context).text('current_locatoin')),
          icon: const Icon(Icons.location_on),
          backgroundColor: Colors.pink,
        ),
        appBar: AppBar(
          backgroundColor: ColorsConts.primaryColor,
          title: Text(I18NTranslations.of(context).text('map')),
        ),
        body: _latitude == null
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
        target: LatLng(_latitude!, _longitude!),
        zoom: 14.5,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('destination'),
          position: LatLng(_latitude!, _longitude!),
        ),
      },
      onTap: _onTap,
      onMapCreated: (controller) {
        _googelMapController.complete(controller);
      },
    );
  }
}
