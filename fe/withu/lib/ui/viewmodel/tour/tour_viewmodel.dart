import 'package:flutter/cupertino.dart';
import 'package:withu/data/model/tourplace.dart';
import 'package:withu/data/repository/tour_repository.dart';

class TourViewModel with ChangeNotifier {
  final TourRepository _repository = TourRepository();
  List<TourPlace>? _tourList;
  List<TourPlace> get tourList => _tourList ?? List.empty();

  Future<void> getTourList(double lat, double lng) async {
    _tourList = await _repository.getTouristSpot(lat, lng);
    notifyListeners();
  }
}