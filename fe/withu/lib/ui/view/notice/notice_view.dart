import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/extension/string_extension.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/global/custom_shadow.dart';
import 'package:withu/ui/view/notice/add_notice_view.dart';
import 'package:withu/ui/viewmodel/notice/notice_viewmodel.dart';

import '../../../data/model/member.dart';
import '../../global/color_data.dart';
import '../../page/notice/add_notice_page.dart';
import 'noticedetail_view.dart';

class NoticeView extends StatefulWidget {
  final Member? _member;

  NoticeView(this._member, {super.key});

  @override
  State<StatefulWidget> createState() => _NoticeView(_member);
}

class _NoticeView extends State<NoticeView> {
  final Member? _member; //로그인 한 유저 정보
  late NoticeViewModel _viewModel;

  _NoticeView(this._member);

  void initData(bool isNew) async {
    await _viewModel.getTeamNotice(isNew);
    await _viewModel.getPinnedNotice(isNew);
  }

  @override
  Widget build(BuildContext context) {
    //build 후 콜백 호출
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initData(false);
    });
    _viewModel = Provider.of<NoticeViewModel>(context, listen: true);
    return Scaffold(
        appBar: CustomAppBar.getNavigationBar(context, '', () => Navigator.pop(context)),
        floatingActionButton: _floatBtn(),
        body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: Column(
              children: [_topView(), _noticeList()],
            )));
  }

  Widget _topView() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(bottom: 10, left: 24, right: 0, top: 0),
            height: 84,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text('공지사항',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
            )),
        Container(
          height: 90,
          margin: EdgeInsets.only(bottom: 10, left: 24, right: 24, top: 20),
          padding: EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: ColorData.COLOR_LIGHTGRAY,
            boxShadow: [CustomShadow.DROP_SHADOW],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Image.asset('assets/images/icon_notice.png',
                        width: 20, height: 20),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Container(
                  padding: EdgeInsets.only(top: 14),
                  child: Text(
                    maxLines: 1,
                _viewModel.pinnedNotice == null ? '' :  _viewModel.pinnedNotice!.title.insertZwj(),
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: ColorData.COLOR_SUBCOLOR1,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                )
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _noticeList() {
    return Expanded(
        child: ListView.builder(
      itemCount: _viewModel.noticeList.length, // 데이터의 총 개수
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => NoticeDetailView(_viewModel.noticeList[index])));
            },
            child: Container(
            margin: EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 0),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 160,
                        height: 50,
                        child: Text(_viewModel.noticeList[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            // 제목
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                      ),
                      SizedBox(height: 8),
                      Container(
                          width: 200,
                          child: Text(
                          _viewModel.noticeList[index].content.substring(
                              0,
                              _viewModel.noticeList[index].content.length > 50
                                  ? 50
                                  : _viewModel
                                      .noticeList[index].content.length), // 내용
                          style: TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis))
                    ],
                  ),
                  _viewModel.noticeList[index].images.isNotEmpty ?
                  Container(
                    width: 72,
                    height: 72,
                    child: Image.file(File(_viewModel.noticeList[index].images.first.imageUrl), fit: BoxFit.cover),
                  )
                      :
                  Container()
                ],
              ),
            )));
      },
    ));
  }

  Widget _floatBtn() {
    if (_member?.role! == 'LEADER') {
      return Container(
        width: 70,
        height: 70,
        child: FloatingActionButton.large(
            onPressed: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => AddNoticePage()))
                  .then((value) => {
                    setState(() {
                      initData(true);
                    })
                });
              },
            backgroundColor: ColorData.COLOR_SUBCOLOR1,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            child: Padding(
                padding: EdgeInsets.only(left: 4, top: 0, right: 0, bottom: 0),
                child: Image.asset('assets/images/icon_writetext.png',
                    width: 40, height: 40))),
      );
    } else {
      return SizedBox(width: 0, height: 0);
    }
  }
}
