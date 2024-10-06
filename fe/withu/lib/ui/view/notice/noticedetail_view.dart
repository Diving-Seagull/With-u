import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:withu/ui/global/custom_appbar.dart';

import '../../../data/api/image_convert.dart';
import '../../../data/model/notice.dart';

class NoticeDetailView extends StatelessWidget {
  final Notice notice;
  NoticeDetailView(this.notice, {super.key});
  late double _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar.getNavigationBar(context, '', () => Navigator.pop(context)),
      body: SafeArea(
        top: false,
        bottom: true,
        left: true,
        right: true,
        child:  SingleChildScrollView(
          child: Column(
            children: [
              Text('공지사항'),
              Text(notice.title),
              Text('${notice.authorName} | ${notice.createdAt}'),
              _setPhotoView(),
              Text(notice.content)
            ],
          ),
        )
      ),
    );
  }

  Widget _setPhotoView() {
    final PageController _controller = PageController(viewportFraction: 0.9);
    return Container(
        height: 200,

        child: PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            itemCount: notice.images.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                width: _deviceWidth,
                child: Image(image: MemoryImage(ImageConvert.decodeBase64(notice.images[index].imageData)), fit: BoxFit.cover),
              );
    }));
  }
}