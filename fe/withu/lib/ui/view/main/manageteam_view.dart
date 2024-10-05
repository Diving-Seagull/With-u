import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/viewmodel/main/manageteam_viewmodel.dart';

import '../../../data/model/member.dart';

class ManageTeamView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ManageTeamView();
}

class _ManageTeamView extends State<ManageTeamView> {
  late ManageTeamViewModel _viewModel;

  void init() async{
    await _viewModel.getTeamMember();
  }

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<ManageTeamViewModel>(context, listen: true);
    init();
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(context, '', () => Navigator.pop(context)),
      body: SafeArea(
          left: true,
          right: true,
          top: true,
          bottom: true,
          child: ListView.builder(
              itemCount: _viewModel.memberList.length,
              itemBuilder: (context, index){
                return Container(
                  height: 60,
                  child: Row(
                    children: [
                      Image.network(_viewModel.memberList[index].profile,
                          width: 40, height: 40),
                      Text(_viewModel.memberList[index].name),
                      GestureDetector(
                          onTap: (){
                            removeMember(_viewModel.memberList[index]);
                          },
                          child: Image.asset('assets/images/icon_cancel.png', width: 32, height: 32))
                    ],
                  ),
                );
              })),
    );
  }

  void removeMember(Member member) async {
    int result = await _viewModel.removeTeamMember(member.id!);
    if(result != -1) {
      CustomDialog.showYesDialog(context, '알림', '${member.name}님의 정보가 삭제되었습니다.', () {
        Navigator.pop(context);
        init();
      });
    }
  }
}