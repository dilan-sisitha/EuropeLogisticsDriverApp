import 'dart:async';

import 'package:euex/models/order.dart';
import 'package:euex/services/activeOrderService.dart';
import 'package:euex/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:location/location.dart' as locations;

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({Key? key, this.order}) : super(key: key);
  final Order? order;

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polyLines = {};
  final Completer<GoogleMapController> _googleMapController = Completer();
  StreamController<bool> adminAddressStreamer = StreamController<bool>();
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(51.509865,-0.118092),
    zoom: 14.4746,
  );
  late BitmapDescriptor pinLocationIcon;
  locations.LocationData? currentLocation;
  Timer? addressCheckTimer;
  bool _showLoadingAddress = false;
  bool _updateCurrentLocationFirebase = false;

  @override
  void initState() {
    _updateCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<Order>>(
        valueListenable: Hive.box<Order>('current_orders').listenable(),
        builder: (context, Box<Order> orderBox, widget) {
          return GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              myLocationEnabled: true,
              markers: markers,
              polylines: Set<Polyline>.of(polyLines.values),
              onMapCreated: (controller) async {
                _googleMapController.complete(controller);
                await _onMapCreated(controller, orderBox);
              });
        });
  }

  Future<void> _onMapCreated(
      GoogleMapController controller, Box orderBox) async {
    bool adminShowAddress = false;
    bool hasAddress = false;
    Order? currentOrder = _getCurrentOrder(orderBox);
    if (currentOrder != null) {
      _showAddressOnTime(currentOrder.logisticTime);
      ActiveOrderService()
          .showAddressByAdmin(currentOrder.orderId, adminAddressStreamer);
      _showLoadingAddress =
          ActiveOrderService().checkLogisticTime(currentOrder.logisticTime!);
      adminAddressStreamer.stream.listen(
        (value) => setState(() {
          adminShowAddress = value;
        }),
      );
      if (_showLoadingAddress || adminShowAddress) {
        hasAddress = await _displayAddress(currentOrder);
      }
    }
    if (!hasAddress) {
      await _displayCurrentPosition();
    }
  }

  _updateCurrentLocation() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(10, 10)),
        'asset/images/map_marker.png');

    locations.Location location = locations.Location();
    location.onLocationChanged.listen((locations.LocationData cLoc) {
      var currentOrderBox = Hive.box<Order>('current_orders');
      Order? currentOrder = _getCurrentOrder(currentOrderBox);
      _updateCurrentLocationFirebase = (currentOrder != null) ? ActiveOrderService().checkLogisticTime(currentOrder.logisticTime.toString()) : false;
      (_updateCurrentLocationFirebase) ? LocationService().updateLocationToFirebase(cLoc) : '';
      currentLocation = cLoc;
      var pinPosition = LatLng(currentLocation!.latitude as double,
          currentLocation!.longitude as double);
      if (mounted) {
        setState(() {
          markers.removeWhere((m) => m.markerId.value == 'sourcePin');
          markers.add(Marker(
              markerId: const MarkerId('sourcePin'),
              position: pinPosition,
              icon: pinLocationIcon
              // updated position
              ));
        });
      }
    });
  }

  void checkBounds(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    c.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90)
      checkBounds(u, c);
  }

  Order? _getCurrentOrder(orderBox) {
    Order? currentOrder;
    if (widget.order != null) {
      Iterable<Order>? orders =
          orderBox.values.where((item) => item.id == widget.order?.id);
      if (orders!.isNotEmpty) {
        currentOrder = orders.first;
      }
    } else if (orderBox.isNotEmpty) {
      currentOrder = orderBox.values.first;
    }
    return currentOrder;
  }

  Future<bool> _displayAddress(currentOrder) async {
    bool hasRoute = false;
    Map currentAddresses =
        LocationService().orderAddressLocations(currentOrder);
    GoogleMapController controller = await _googleMapController.future;
    if (currentAddresses['from'] is String && currentAddresses['to'] == null) {
      geo.Location? fromGeoCode =
          await LocationService().getCoordinates(currentAddresses['from']);
      if (fromGeoCode != null) {
        setState(() {
          markers.removeWhere((m) => m.markerId.value == 'start_marker');
          markers.removeWhere((m) => m.markerId.value == 'destination_marker');
          markers.add(Marker(
            markerId: const MarkerId('start_marker'),
            position: LatLng(fromGeoCode.latitude,
                fromGeoCode.longitude), // updated position
          ));
        });
        hasRoute = true;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(fromGeoCode.latitude, fromGeoCode.longitude),
              zoom: 16.0,
            ),
          ),
        );
      }
    } else if (currentAddresses['from'] != null &&
        currentAddresses['to'] != null) {
      geo.Location? fromGeoCode =
          await LocationService().getCoordinates(currentAddresses['from']);
      geo.Location? toGeocode =
          await LocationService().getCoordinates(currentAddresses['to']);
      LocationService().getDirections(
          currentAddresses['from'], currentAddresses['to'], markers, polyLines);
      if (fromGeoCode != null && toGeocode != null) {
        hasRoute = true;
        LatLng fromLatLng = LatLng(fromGeoCode.latitude, fromGeoCode.longitude);
        LatLng toLatLng = LatLng(toGeocode.latitude, toGeocode.longitude);
        LatLngBounds bound = LocationService().getBounds(fromLatLng, toLatLng);
        CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
        checkBounds(u2, controller);
      }
    }
    return hasRoute;
  }

  _displayCurrentPosition() async {
    GoogleMapController controller = await _googleMapController.future;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
      ),
    );
  }

  void _showAddressOnTime(logisticTime) {
    if (mounted) {
      addressCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (mounted) {
          setState(() {
            _showLoadingAddress =
                ActiveOrderService().checkLogisticTime(logisticTime);
          });
        }
        if (_showLoadingAddress) {
          timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    adminAddressStreamer.close();
    _googleMapController.future.then((value) => value.dispose());
    if (addressCheckTimer is Timer) {
      addressCheckTimer!.cancel();
    }
    ActiveOrderService().stopCheckAddressListener();
    super.dispose();
  }
}
