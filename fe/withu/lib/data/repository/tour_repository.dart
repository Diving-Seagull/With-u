import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:withu/data/datasource/tour_datasource.dart';
import 'package:withu/data/model/tourplace.dart';

class TourRepository {
  final TourDataSource _dataSource = TourDataSource();
  final FlutterSecureStorage storage = FlutterSecureStorage();

  Future<List<TourPlace>?> getTouristSpot(double lat, double lng) async {
    String? jwtToken = await storage.read(key: 'jwtToken') as String;
    return _dataSource.getTouristSpots(jwtToken, lat, lng);
  }
}