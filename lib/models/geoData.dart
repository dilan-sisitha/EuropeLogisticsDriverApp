import 'package:hive_flutter/hive_flutter.dart';

part 'geoData.g.dart';

@HiveType(typeId: 5)
class GeoData extends HiveObject {
  @HiveField(0)
  int orderId;

  @HiveField(1)
  double? loadingLng;

  @HiveField(2)
  double? loadingLat;

  @HiveField(3)
  double? unloadingLng;

  @HiveField(4)
  double? unloadingLat;

  GeoData(
      {required this.orderId,
      this.loadingLng,
      this.loadingLat,
      this.unloadingLng,
      this.unloadingLat});

  fistOrCreate() {
    var geoDataBox = Hive.box<GeoData>('order_geo_data');
    if (!geoDataBox.containsKey(orderId.toString())) {
      geoDataBox.put(orderId.toString(), GeoData(orderId: orderId));
    }
    return geoDataBox.get(orderId.toString());
  }

  Future<GeoData?> get find async {
    dynamic geoData;
    var geoDataBox = await Hive.openBox<GeoData>('order_geo_data');
    //var geoDataBox = Hive.box<GeoData>('order_geo_data');
    if (geoDataBox.containsKey(orderId.toString())) {
      geoData = geoDataBox.get(orderId.toString());
    }
    geoDataBox.close();
    return geoData;
  }
}
