import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/init_member.dart';
import 'package:withu/ui/viewmodel/login/teamcode_viewmodel.dart';

import '../../global/color_data.dart';
import '../../global/custom_appbar.dart';
import '../../global/custom_dialog.dart';
import '../../page/main/home_page.dart';

class TeamCodeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TeamCodeView();
}

class _TeamCodeView extends State<TeamCodeView> {
  late TeamCodeViewModel _viewModel;
  late double _deviceWidth, _deviceHeight;
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  var btn_color = ColorData.COLOR_GRAY;
  var text_color = ColorData.COLOR_DARKGRAY;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<TeamCodeViewModel>(context);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: CustomAppBar.getNavigationBar(
            context, '초대코드', () => Navigator.pop(context)),
        body: SafeArea(
          top: true,
          bottom: true,
          left: true,
          right: true,
          child: Center(
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "초대코드 입력",
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text("팀별 초대코드 6자리를 입력해주세요.",
                        style: TextStyle(
                            fontSize: 14, color: ColorData.COLOR_DARKGRAY)),
                    SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          height: 60,
                          width: (_deviceWidth - 90) / 6, // 각 텍스트 필드의 너비
                          child: CupertinoTextField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                            maxLength: 1,
                            // 한 글자만 입력 가능
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              // 숫자만 입력 가능
                            ],
                            onChanged: (value) {
                              // 자동으로 다음 필드로 포커스 이동
                              if (index < 5) {
                                if (value.length == 1) {
                                  FocusScope.of(context).nextFocus();
                                } else if (index > 0) {
                                  FocusScope.of(context).previousFocus();
                                }
                              } else if (index == 5) {
                                if (value.length == 1) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    btn_color = ColorData.COLOR_SUBCOLOR1;
                                    text_color = Colors.white;
                                  });
                                } else {
                                  FocusScope.of(context).previousFocus();
                                  setState(() {
                                    btn_color = ColorData.COLOR_GRAY;
                                    text_color = ColorData.COLOR_DARKGRAY;
                                  });
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 62),
                    SizedBox(
                        width: _deviceWidth,
                        child: CupertinoButton(
                            child: Text(
                              'Continue',
                              style: TextStyle(color: text_color, fontSize: 16),
                            ),
                            color: btn_color,
                            onPressed: () async {
                              if (btn_color == ColorData.COLOR_SUBCOLOR1) {
                                  var result = await _viewModel.initMemberInfo(_controllers.map((value) => value.text).toList().join(''));
                                  if(result != null) {
                                    CustomDialog.showYesDialog(context, '알림', '회원가입이 완료되었습니다!', () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context, CupertinoPageRoute(builder: (context) => HomePage()));
                                    });
                                  }
                              }
                            }))
                  ],
                )),
          ),
        ));
  }
}
