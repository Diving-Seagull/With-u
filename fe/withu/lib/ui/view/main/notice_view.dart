import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/notice.dart';
import 'package:withu/ui/viewmodel/main/notice_viewmodel.dart';

class NoticeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NoticeView();
}

class _NoticeView extends State<NoticeView> {
  late NoticeViewModel _viewModel;

  void initData() async {
    await _viewModel.getTeamNotice(1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _viewModel = Provider.of<NoticeViewModel>(context, listen: true);
    initData();
    return Scaffold(
      appBar: CupertinoNavigationBar(
          middle: Text('Cupertino Style UI',
              style: TextStyle(color: Colors.black))),
      body: Column(
        children: [
          const Text('공지사항'),
          Expanded(
              child: ListView.builder(
                itemCount: _viewModel.noticeList.length, // 데이터의 총 개수
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_viewModel.noticeList[index].title), // 각 항목의 텍스트
                  );
                },
              )
          )
        ],
      ),
    );
  }
}
