import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/memberlocation.dart';
import 'package:withu/ui/global/custom_appbar.dart';

import '../../viewmodel/main/findleader_viewmodel.dart';

class FindLeaderView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FindLeaderView();
}

class _FindLeaderView extends State<FindLeaderView> {
  late FindLeaderViewModel _viewModel;
  final Completer<NaverMapController> mapControllerCompleter = Completer();
  NaverMapController? _controller;
  NLatLng? _currentPosition;
  MemberLocation? leaderLocation;

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
      await _viewModel.getLeaderLocation();
      await setLeaderLocation();
    }
  }

  Future<void> setLeaderLocation() async {
    if (_viewModel.location != null) {
      setState(() {
        _controller!.clearOverlays(); // 마커 제거
        final marker = NMarker(id: '1',
            position: NLatLng(
                _viewModel.location!.latitude, _viewModel.location!.longitude));
        _controller!.addOverlay(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<FindLeaderViewModel>(context, listen: true);
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(context, '팀장 찾기', () => Navigator.pop(context)),
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