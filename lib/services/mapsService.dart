import 'dart:async';

import 'package:euex/config/environment.dart';
import 'package:euex/models/pin_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:location/location.dart' as locations;
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapsService {
  static const LatLng startLocation =
      LatLng(51.40769936277236, 0.018156855275941533);

  static final CameraPosition _initialCameraPosition = const CameraPosition(
    target: startLocation,
    zoom: 11,
    tilt: 59.440717697143555,
    bearing: 192.8334901395799,
  );

  final panelController = PanelController();

  late BitmapDescriptor pinLocationIcon;
  Set<Marker> markers = {};
  Completer<GoogleMapController> _controller = Completer();
  late Position position;

  PolylinePoints polyLinePoints = PolylinePoints();
  final String googleApiKey = Environment.config.googleApiKey;
  Map<PolylineId, Polyline> polylines = {};

  final geocoding =
      GoogleMapsGeocoding(apiKey: Environment.config.googleApiKey);
  late String currentOrderFromAddress;
  late String currentOrderToAddress;
  late String logisticTime;
  late int currentOrderLength;

  late GeocodingResponse startLocationResponse;
  late GeocodingResponse endLocationResponse;
  late LatLng latLng_1;
  late LatLng latLng_2;

  late LatLng updatedCameraPosition;

  late locations.LocationData currentLocation;
  late locations.Location location;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: const LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  double pinPillPosition = -100;
  late bool collectionDocStatus;
  late bool deliveryDocStatus;

  initMaps() {}
}
