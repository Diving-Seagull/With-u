import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/viewmodel/main/notice_viewmodel.dart';

import '../../../data/model/member.dart';

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

  void initData() async {
    await _viewModel.getTeamNotice();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<NoticeViewModel>(context, listen: true);
    initData();
    return Scaffold(
        appBar: CustomAppBar.getNavigationBar(context, ''),
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Column(
            children: [
              _noticeList()

            ],
          )
        )
    );
  }

  Widget _noticeList() {
    return Expanded(child: ListView.builder(
              itemCount: _viewModel.noticeList.length, // 데이터의 총 개수
              itemBuilder: (context, index) {
                return
                  Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 0, bottom: 4, left: 0, right: 0),
                                  child: Text(_viewModel.noticeList[index].title, // 제목
                                      style:
                                      TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                                ),
                                Text(_viewModel.noticeList[index].content.substring(0,
                                    _viewModel.noticeList[index].content.length > 50 ?
                                    50 : _viewModel.noticeList[index].content.length), // 내용
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                            Container(
                              width: 72,
                              height: 72,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      )
                  );
              },
      )
    );
  }
}
