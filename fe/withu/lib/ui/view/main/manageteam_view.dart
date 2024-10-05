import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/global/bottom_modal.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/viewmodel/main/manageteam_viewmodel.dart';

import '../../../data/model/member.dart';
import '../../global/color_data.dart';

class ManageTeamView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManageTeamView();
}

class _ManageTeamView extends State<ManageTeamView> {
  late ManageTeamViewModel _viewModel;
  late double _deviceWidth, _deviceHeight;


  void init() async {
    await _viewModel.getTeamMember();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    _deviceHeight = MediaQuery
        .of(context)
        .size
        .height;
    _viewModel = Provider.of<ManageTeamViewModel>(context, listen: true);
    init();
    return Scaffold(
        appBar: CustomAppBar.getNavigationBar(
            context, '', () => Navigator.pop(context)),
        body: SafeArea(
            left: true,
            right: true,
            top: true,
            bottom: true,
            child: Column(
              children: [
                Container(
                    margin:
                        EdgeInsets.only(bottom: 10, left: 24, right: 0, top: 0),
                    height: 84,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('멤버관리',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                    )),
                Expanded(
                    child: ListView.builder(
                        itemCount: _viewModel.memberList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 10, left: 24, right: 24, top: 0),
                            width: _deviceWidth,
                            height: 60,
                            child: Row(
                              children: [
                                Image.network(
                                    _viewModel.memberList[index].profile,
                                    width: 40,
                                    height: 40),
                                SizedBox(width: 8),
                                SizedBox(width: _deviceWidth - 40 - 32 - 24 - 24 - 8, child: Text(_viewModel.memberList[index].name,
                                style: TextStyle(fontWeight: FontWeight.w500))),
                                GestureDetector(
                                    onTap: () {
                                      CustomDialog.showYesNoDialog(context, '멤버 삭제', '정말로 삭제하시겠습니까?', () {
                                        removeMember(
                                            _viewModel.memberList[index]);
                                      }, () => Navigator.pop(context));
                                    },
                                    child: Image.asset(
                                        'assets/images/icon_cancel.png',
                                        width: 32,
                                        height: 32))
                              ],
                            ),
                          );
                        }))
              ],
            )));
  }

  void removeMember(Member member) async {
    int result = await _viewModel.removeTeamMember(member.id!);
    if (result != -1) {
      CustomDialog.showYesDialog(context, '알림', '${member.name}님의 정보가 삭제되었습니다.',
          () {
        Navigator.pop(context);
        init();
      });
    }
  }
}
