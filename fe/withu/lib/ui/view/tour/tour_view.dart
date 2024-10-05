import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:withu/extension/string_extension.dart';
import 'package:withu/ui/global/bottom_modal.dart';
import 'package:withu/ui/global/color_data.dart';
import 'package:withu/ui/global/custom_appbar.dart';
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
  NLatLng? _currentPosition;
  late double _deviceWidth, _deviceHeight;

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
      await _viewModel.getTourList(
          _currentPosition!.latitude, _currentPosition!.longitude);
      setTourData();
    }
  }

  Future<void> setTourData() async {
    setState(() {
      _controller!.clearOverlays(); // 마커 제거
      for (var tour in _viewModel.tourList) {
        final marker = NMarker(
            id: tour.id.toString(),
            position: NLatLng(tour.latitude, tour.longitude));
        marker.setCaption(NOverlayCaption(text: tour.name));
        marker.setOnTapListener((marker) {
          _tourInfo(tour);
        });
        _controller!.addOverlay(marker);
      }
      _tourListInfo();
    });
  }

  void _tourListInfo() {
    if(_viewModel.tourList.isNotEmpty) {
      var firstAddr = _viewModel.tourList.first.address;
      var text = firstAddr.substring(0, firstAddr.indexOf(' '));
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: EdgeInsets.all(24),
              width: _deviceWidth,
              height: 350,
              // 모달 높이 크기
              decoration: const BoxDecoration(
                color: Colors.white, // 모달 배경색
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), // 모달 좌상단 라운딩 처리
                  topRight: Radius.circular(40), // 모달 우상단 라운딩 처리
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('${text}에 방문하셨군요!', style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Pretendard',
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none),
                ),
                SizedBox(height: 10),
                Text('${text}의 유명 관광지를 추천해드릴게요!', style: TextStyle(
                    color: ColorData.COLOR_DARKGRAY,
                    fontFamily: 'Pretendard',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none)),
                    SizedBox(height: 20),
                Container(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _viewModel.tourList.length,
                        itemBuilder: (context, index) {
                          var tour = _viewModel.tourList[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tour.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pretendard',
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    decoration: TextDecoration.none),
                                maxLines: 2,
                              ),
                              SizedBox(height: 10),
                              Text(
                                tour.address.insertZwj(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none),
                                maxLines: 2,
                              ),
                              SizedBox(height: 28),
                              Text(
                                tour.description.insertZwj(),
                                style: TextStyle(
                                    color: ColorData.COLOR_DARKGRAY,
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.none),
                              ),
                              SizedBox(height: 40)
                            ],
                          );
                        }))
              ]) // 모달 내부 디자인 영역
          );
        },
      );
    }
  }

  void _tourInfo(TourPlace tour) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(24),
          width: _deviceWidth,
          height: 300,
          // 모달 높이 크기
          decoration: const BoxDecoration(
            color: Colors.white, // 모달 배경색
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), // 모달 좌상단 라운딩 처리
              topRight: Radius.circular(40), // 모달 우상단 라운딩 처리
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  tour.address.insertZwj(),
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none),
                  maxLines: 2,
                ),
                SizedBox(height: 28),
                Text(
                  tour.description.insertZwj(),
                  style: TextStyle(
                      color: ColorData.COLOR_DARKGRAY,
                      fontFamily: 'Pretendard',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
          ), // 모달 내부 디자인 영역
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<TourViewModel>(context, listen: true);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(
          context, '관광지도', () => Navigator.pop(context)),
      body: NaverMap(
        options: const NaverMapViewOptions(
          locationButtonEnable: true,
        ),
        onMapReady: (controller) async {
          // 지도 준비 완료 시 호출되는 콜백 함수
          _controller = controller;
          init();
          mapControllerCompleter
              .complete(controller); // Completer에 지도 컨트롤러 완료 신호 전송
          print("onMapReady");
        },
        onMapTapped: (point, nLatLng) {
          _currentPosition = nLatLng;
          _moveCameraToCurrentPosition();
        },
      ),
    );
  }
}
