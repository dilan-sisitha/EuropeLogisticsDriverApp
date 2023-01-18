import 'package:euex/database/firebasertRtDb.dart';
import 'package:euex/helpers/stringFormatter.dart';
import 'package:euex/models/geoData.dart';
import 'package:euex/models/order.dart';
import 'package:euex/providers/networkConnectivityProvider.dart';
import 'package:euex/services/SettingService.dart';
import 'package:euex/services/clearanceDocService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart'
    as poly_line;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../config/environment.dart';

class LocationService {
  static LocationData? currentLocation;
  static String googleApiKey = Environment.config.googleApiKey;
  final geocoding = GoogleMapsGeocoding(apiKey: googleApiKey);
  poly_line.PolylinePoints polyLinePoints = poly_line.PolylinePoints();

  updateLocationToFirebase(LocationData location) async {
    currentLocation = location;
    final locationDataDBRef =
         FirebaseRealtimeDataBase().ref('/location_data');
    final appDataDBRef =  FirebaseRealtimeDataBase().ref('/app_data');
    dynamic currentTime = DateFormat.jm().format(DateTime.now());
    await locationDataDBRef
        .set({"longitude": location.longitude, "latitude": location.latitude});
    await appDataDBRef.update({"last_updated_on": currentTime});
  }

  getDirections(String currentOrderFromAddress, String currentOrderToAddress,
      Set<Marker> markers, Map<PolylineId, Polyline> polyLines) async {
    geo.Location? startGeoCode = await getCoordinates(currentOrderFromAddress);
    geo.Location? endGeoCode = await getCoordinates(currentOrderToAddress);
    if (startGeoCode != null && endGeoCode != null) {
      markers.add(Marker(
          markerId: const MarkerId('start_marker'),
          position: LatLng(startGeoCode.latitude, startGeoCode.longitude),
          icon: BitmapDescriptor.defaultMarker));
      markers.add(Marker(
          markerId: const MarkerId('destination_marker'),
          position: LatLng(endGeoCode.latitude, endGeoCode.longitude),
          icon: BitmapDescriptor.defaultMarker));
      List<LatLng> polylineCoordinates = [];
      poly_line.PolylineResult result =
          await polyLinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        poly_line.PointLatLng(startGeoCode.latitude, startGeoCode.longitude),
        poly_line.PointLatLng(endGeoCode.latitude, endGeoCode.longitude),
        travelMode: poly_line.TravelMode.driving,
      );

      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      } else {
        debugPrint(result.errorMessage);
      }
      addPolyLine(polylineCoordinates, polyLines);
    }
  }

  addPolyLine(
      List<LatLng> polylineCoordinates, Map<PolylineId, Polyline> polyLines) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polyLines[id] = polyline;
  }

  double? calculateDistanceFromCurrentLocation(double lat, double lng) {
    double? distance;
    if (currentLocation != null) {
      distance = Geolocator.distanceBetween(currentLocation!.latitude!,
              currentLocation!.longitude!, lat, lng) /
          1000;
    }
    return distance;
  }

  Future<geo.Location?> getCoordinates(String address) async {
    try{
      geo.Location? coordinates;
      String text = StringFormatter().formatAddressForSearch(address);
      if (await NetworkConnectivityProvider().tryConnection()) {
        List<geo.Location> geoCode = await geo.locationFromAddress(text);
        if (geoCode.isNotEmpty) {
          coordinates = geoCode.first;
        }
      }
      return coordinates;
    }
    catch(e){
      print('ERROR : '+e.toString());
    }

  }

  Map getCurrentOrderAddresses() {
    late String currentOrderFromAddress;
    late String currentOrderToAddress;
    var currentOrder = Hive.box<Order>('current_orders').values.first;
    bool collectionDocStatus = ClearanceDocService()
        .checkClearanceDocStatus(currentOrder.id, 'collection');
    bool deliveryDocStatus = ClearanceDocService()
        .checkClearanceDocStatus(currentOrder.id, 'delivery');
    if (!collectionDocStatus && !deliveryDocStatus) {
      currentOrderFromAddress = currentOrder.fromAddress;
      currentOrderToAddress =
          currentOrder.documentPickupPoint.toString();
    } else if (collectionDocStatus && !deliveryDocStatus) {
      currentOrderFromAddress =
          currentOrder.documentPickupPoint.toString();
      currentOrderToAddress = currentOrder.documentReleasePoint.toString();
    } else if (collectionDocStatus && deliveryDocStatus) {
      currentOrderFromAddress =
          currentOrder.documentReleasePoint.toString();
      currentOrderToAddress = currentOrder.toAddress;
    }
    return {
      'fromAddress': currentOrderFromAddress,
      'toAddress': currentOrderToAddress
    };
  }

  LatLngBounds getBounds(LatLng offerLatLng, LatLng currentLatLng) {
    LatLngBounds bound;
    if (offerLatLng.latitude > currentLatLng.latitude &&
        offerLatLng.longitude > currentLatLng.longitude) {
      bound = LatLngBounds(southwest: currentLatLng, northeast: offerLatLng);
    } else if (offerLatLng.longitude > currentLatLng.longitude) {
      bound = LatLngBounds(
          southwest: LatLng(offerLatLng.latitude, currentLatLng.longitude),
          northeast: LatLng(currentLatLng.latitude, offerLatLng.longitude));
    } else if (offerLatLng.latitude > currentLatLng.latitude) {
      bound = LatLngBounds(
          southwest: LatLng(currentLatLng.latitude, offerLatLng.longitude),
          northeast: LatLng(offerLatLng.latitude, currentLatLng.longitude));
    } else {
      bound = LatLngBounds(southwest: offerLatLng, northeast: currentLatLng);
    }
    return bound;
  }

  Future<bool> checkValidLoadingRadius(orderId, context) async {
    bool isValid = true;
    GeoData? geoData = await GeoData(orderId: orderId).find;
    if (geoData != null &&
        geoData.loadingLat != null &&
        geoData.loadingLng != null) {
      double? distance = LocationService().calculateDistanceFromCurrentLocation(
          geoData.loadingLat!, geoData.loadingLng!);
      if (distance != null) {
        int? maximumDistance = await SettingService()
            .getSetting(SettingService.loadingTimerStopRadius);
        if (maximumDistance != null && distance > maximumDistance) {
          isValid = false;
        }
      }
    }
    return isValid;
  }

  Future<bool> checkValidUnloadingRadius(orderId, context) async {
    bool isValid = true;
    GeoData? geoData = await GeoData(orderId: orderId).find;
    if (geoData != null &&
        geoData.unloadingLat != null &&
        geoData.unloadingLng != null) {
      double? distance = LocationService().calculateDistanceFromCurrentLocation(
          geoData.unloadingLat!, geoData.unloadingLng!);
      if (distance != null) {
        int? maximumDistance = await SettingService()
            .getSetting(SettingService.unloadingTimerStopRadius);
        if (maximumDistance != null && distance > maximumDistance) {
          isValid = false;
        }
      }
    }
    return isValid;
  }

  updateOrderLoadingGeoCodes(orderId, String fromAddress) async {
    geo.Location? geoCode = await LocationService().getCoordinates(fromAddress);
    if (geoCode != null) {
      var geoDataBox = await Hive.openBox<GeoData>('order_geo_data');
      GeoData geoData = GeoData(orderId: orderId).fistOrCreate();
      geoData.loadingLat = geoCode.latitude;
      geoData.loadingLng = geoCode.longitude;
      await geoData.save();
      geoDataBox.close();
    }
  }

  updateOrderUnloadingGeoCodes(orderId, String toAddress) async {
    geo.Location? geoCode = await LocationService().getCoordinates(toAddress);
    if (geoCode != null) {
      var geoDataBox = await Hive.openBox<GeoData>('order_geo_data');
      GeoData geoData = GeoData(orderId: orderId).fistOrCreate();
      geoData.unloadingLat = geoCode.latitude;
      geoData.unloadingLng = geoCode.longitude;
      await geoData.save();
      geoDataBox.close();
    }
  }

  Map orderAddressLocations(Order order) {
    String from;
    String? to;
    bool collectionDocStatus = ClearanceDocService()
        .checkClearanceDocStatus(order.id, 'collection');
    bool deliveryDocStatus =
        ClearanceDocService().checkClearanceDocStatus(order.id, 'delivery');
    from = order.fromAddress;
    if (order.status == 3) {
      if (order.documentPickupPoint != null && !collectionDocStatus) {
        to = order.documentPickupPoint;
      }
    } else if (order.status == 4) {
      if (order.documentPickupPoint != null && !collectionDocStatus) {
        from = order.documentPickupPoint.toString();
      }
      if (order.documentReleasePoint != null && !deliveryDocStatus) {
        to = order.documentReleasePoint;
      } else {
        to = order.toAddress;
      }
    }
    return {'from': from, 'to': to};
  }
}
