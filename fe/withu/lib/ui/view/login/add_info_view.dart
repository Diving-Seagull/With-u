import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/init_member.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/global/device_info.dart';
import 'package:withu/ui/global/color_data.dart';
import 'package:withu/ui/page/main/home_page.dart';
import 'package:withu/ui/view/login/teamcode_view.dart';
import 'package:withu/ui/view/main/home_view.dart';
import 'package:withu/ui/viewmodel/login/add_info_viewmodel.dart';
import '../../../data/model/role.dart';
import '../../page/login/teamcode_page.dart';

class AddInfoView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddInfoView();
}

class _AddInfoView extends State<AddInfoView> {
  late AddInfoViewModel _viewModel;
  final ColorData colorData = ColorData();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  late double _deviceWidth, _deviceHeight;

  void init() async {
    if(_viewModel.member == null) {
      await _viewModel.getMemberInfo();
      _nameController.text = _viewModel.member?.name ?? '';
      _descController.text = _viewModel.member?.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    _viewModel = Provider.of<AddInfoViewModel>(context, listen: true);
    init();
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            top: true,
            bottom: true,
            left: true,
            right: true,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_photoSection(), _infoSection(), _saveSection(context)],
              ),
            )));
  }

  Widget _photoSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  )
                ]),
            child: SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(_viewModel.member?.profile ?? '',
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      )
                    ]),
                child: Image.asset('assets/images/icon_photo.png'),
              ))
        ],
      ),
    );
  }

  Widget _infoSection() {
    return Column(
      children: [
        // 닉네임 입력란
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "닉네임",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ColorData.COLOR_DARKGRAY,
                      fontSize: 18),
                ),
                Text(
                  "${_nameController.text.length}/20",
                  style:
                      TextStyle(color: ColorData.COLOR_SEMIGRAY, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        Container(
          child: CupertinoTextField(
              keyboardType: TextInputType.name,
              placeholder: '닉네임을 입력해주세요',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorData.COLOR_LIGHTGRAY,
              ),
              controller: _nameController,
              onChanged: (text) {
                setState(() {
                  _nameController.text = text;
                });
              }),
          height: 48,
        ),

        // 한 줄 소개 입력란
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "한 줄 소개",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ColorData.COLOR_DARKGRAY,
                      fontSize: 18),
                ),
                Text(
                  "${_descController.text.length}/50",
                  style:
                      TextStyle(color: ColorData.COLOR_SEMIGRAY, fontSize: 12),
                ),
              ],
            )
          ],
        ),

        Container(
          child: CupertinoTextField(
              keyboardType: TextInputType.name,
              placeholder: '자신을 소개하는 글을 적어보세요!',
              textAlignVertical: TextAlignVertical.top,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorData.COLOR_LIGHTGRAY,
              ),
              controller: _descController,
              onChanged: (text) {
                setState(() {
                  _descController.text = text;
                });
              }),
          height: 150,
        ),

        // 팀장, 팀명 선택란
        // Column(
        //   children: [
        //     Container(
        //       width: _deviceWidth,
        //       child: Text(
        //         "역할 선택",
        //         style: TextStyle(
        //             fontWeight: FontWeight.w700,
        //             color: ColorData.COLOR_DARKGRAY,
        //             fontSize: 18),
        //       ),
        //     ),
        //     Row(
        //       children: [
        //         Expanded(
        //             child: RadioListTile(
        //                 title: Text("팀장"),
        //                 value: Role.LEADER,
        //                 groupValue: _role,
        //                 onChanged: (role) {
        //                   setState(() {
        //                     _role = role;
        //                     print(_role);
        //                   });
        //                 })),
        //         Expanded(
        //           child: RadioListTile(
        //               title: Text("팀원"),
        //               value: Role.TEAMMATE,
        //               groupValue: _role,
        //               onChanged: (role) {
        //                 setState(() {
        //                   _role = role;
        //                   print(_role);
        //                 });
        //               }),
        //         )
        //       ],
        //     ),
        //   ],
        // )
      ],
    );
  }

  Widget _saveSection(BuildContext context) {
    return Container(
      width: _deviceWidth,
      child: CupertinoButton.filled(child: Text('저장하기'), onPressed: () {
        _saveMemberData(context);
      }),
    );
  }

  void _saveMemberData(BuildContext ct) async {
    var deviceInfo = await DeviceInfo.getDeviceInfo();
    var data = InitMember(
        role: _viewModel.type,
        name: _nameController.text,
        description: _descController.text,
        deviceUuid: deviceInfo['device_id']!,
        profileImage: _viewModel.member?.profile ?? '',
        teamCode: null);

    if (_viewModel.type == 'LEADER') {
      var result = await _viewModel.initMemberInfo(data);
      if (result != null) {
        if (ct.mounted) {
          CustomDialog.showYesDialog(ct, '알림', '회원가입이 완료되었습니다!', () {
            Navigator.pop(ct);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                ct, CupertinoPageRoute(builder: (context) => HomePage()));
          });
        }
      }
    }
    else {
      if(ct.mounted) {
        Navigator.push(
            ct, CupertinoPageRoute(builder: (context) => TeamCodePage(data)));
      }
    }
  }
}
