import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/tour/tour_viewmodel.dart';

import '../../../data/model/tourplace.dart';
import '../../../data/repository/tour_repository.dart';

class TourView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TourView();
}

class _TourView extends State<TourView> {
  late TourViewModel _viewModel;
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  NaverMapController? _controller;
  List<TourPlace>? _tourList;
  NLatLng? _currentPosition;

  Future<void> init() async {
    // 위치 가져오기
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = NLatLng(position.latitude, position.longitude);
      // 맵 카메라를 현재 위치로 이동
      _moveCameraToCurrentPosition();
    });
  }

  // 맵 카메라를 현재 위치로 이동
  void _moveCameraToCurrentPosition() async {
    if (_currentPosition != null && _controller != null) {
      var camera = NCameraUpdate.scrollAndZoomTo(target: _currentPosition);
      await _controller!.updateCamera(camera);
      await _viewModel.getTourList(_currentPosition!.latitude, _currentPosition!.longitude);
      setTourData();
    }
  }

  Future<void> setTourData() async {
    setState(() {
      _controller!.clearOverlays(); // 마커 제거
      for(var tour in _viewModel.tourList) {
        final marker = NMarker(id: tour.id.toString(), position: NLatLng(tour.latitude, tour.longitude));
        marker.setCaption(NOverlayCaption(text: tour.name));
        marker.setOnTapListener((marker) {

        });
        _controller!.addOverlay(marker);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<TourViewModel>(context, listen: true);
    // TODO: implement build
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          locationButtonEnable: true,
        ),
        onMapReady: (controller) async {  // 지도 준비 완료 시 호출되는 콜백 함수
          _controller = controller;
          init();
          mapControllerCompleter.complete(controller);  // Completer에 지도 컨트롤러 완료 신호 전송
          print("onMapReady");
        },
      ),
    );
  }
}