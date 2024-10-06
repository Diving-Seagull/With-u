import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:withu/data/model/notice_request.dart';
import 'package:withu/ui/global/custom_appbar.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:withu/ui/global/custom_dialog.dart';
import 'package:withu/ui/viewmodel/notice/add_notice_viewmodel.dart';
import 'package:withu/ui/viewmodel/notice/notice_viewmodel.dart';

import '../../../data/model/notice.dart';
import '../../global/bottom_modal.dart';
import '../../global/color_data.dart';

class AddNoticeView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNoticeView();
}

class _AddNoticeView extends State<AddNoticeView> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  bool _isImportant = false;
  late double _deviceWidth, _deviceHeight;
  late AddNoticeViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel = Provider.of<AddNoticeViewModel>(context, listen: true);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(context, '공지사항 작성', () => Navigator.pop(context)),
      body: Container(color: Colors.white, child: _insertSection()),
    );
  }

  Widget _insertSection() {
    return Column(
      children: [
        Text(
          "제목을 입력해주세요.",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: ColorData.COLOR_DARKGRAY,
              fontSize: 18),
        ),
        SizedBox(
          height: 48,
          child: CupertinoTextField(
              keyboardType: TextInputType.name,
              placeholder: '제목',
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorData.COLOR_LIGHTGRAY,
              ),
              controller: _titleController,
              onChanged: (text) {
                setState(() {
                  _titleController.text = text;
                });
              }),
        ),
        Text(
          "내용을 입력해주세요.",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: ColorData.COLOR_DARKGRAY,
              fontSize: 18),
        ),
        SizedBox(
          height: 150,
          child: CupertinoTextField(
              keyboardType: TextInputType.name,
              placeholder: '자신을 소개하는 글을 적어보세요!',
              textAlignVertical: TextAlignVertical.top,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorData.COLOR_LIGHTGRAY,
              ),
              controller: _contentController,
              onChanged: (text) {
                setState(() {
                  _contentController.text = text;
                });
              }),
        ),
        Text(
          "사진을 등록해주세요",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: ColorData.COLOR_DARKGRAY,
              fontSize: 18),
        ),
        Container(
            width: _deviceWidth,
            height: 85,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _viewModel.pickedFiles == null ? 1 : _viewModel.pickedFiles!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      width: 85,
                      height: 85,
                      color: ColorData.COLOR_LIGHTGRAY,
                    ),
                  );
                }
                if (_viewModel.pickedFiles != null) {
                  return Stack(
                    children: [
                      Positioned(
                          bottom: 0,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                  File(_viewModel.pickedFiles![index - 1].path),
                                  fit: BoxFit.cover),
                            ),
                          )),
                      SizedBox(
                        width: 85,
                        height: 85,
                      ),
                      Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
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
                  );
                }
              },
            )
        ),
        Row(
          children: [
            Checkbox(
                value: _isImportant,
                onChanged: (isImportant) {
                  setState(() {
                    _isImportant = isImportant!;
                  });
                }
            ),
            Text('상단 고정')
          ],
        ),
        CupertinoButton.filled(child: Text('저장하기'), onPressed: () {
          //공지사항 저장
          createNotice();
        }),
      ]
    );
  }

  Widget _setPhotoSection() {
    if (_viewModel.pickedFiles == null) {
      return GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: Container(
          width: 85,
          height: 85,
          color: ColorData.COLOR_LIGHTGRAY,
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: Container(
                width: 85,
                height: 85,
                color: ColorData.COLOR_LIGHTGRAY,
              ),
            ),
            SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _viewModel.pickedFiles?.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 85,
                      height: 85,
                      color: ColorData.COLOR_LIGHTGRAY,
                    );
                  },
                ))
          ],
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    // Set to use Android Photo Picker.
    final ImagePickerPlatform picker = ImagePickerPlatform.instance;
    if (picker is ImagePickerAndroid) {
      picker.useAndroidPhotoPicker = true;
    }

    _viewModel.setPickedFiles(await picker.getMultiImageWithOptions(
      options: MultiImagePickerOptions(
        imageOptions: ImagePickerOptions(requestFullMetadata: false),
        limit: 5,
      ),
    ));
  }

  void createNotice() async {
    if(_titleController.text.trim() == '') {
      CustomDialog.showYesDialog(context, '알림', '제목을 입력해주세요.', () => Navigator.pop(context));
      return;
    }
    if(_contentController.text.trim() == '') {
      CustomDialog.showYesDialog(context, '알림', '내용을 입력해주세요.', () => Navigator.pop(context));
      return;
    }

    Notice? result = await _viewModel.addNotice(_titleController.text, _contentController.text, _isImportant);
    if(result != null) {
      CustomDialog.showYesDialog(context, '알림', '공지사항이 등록되었습니다!', () {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
    else {

    }
  }
}
