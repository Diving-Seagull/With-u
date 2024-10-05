import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:withu/ui/viewmodel/timetable/timetable_viewmodel.dart';

import '../../global/color_data.dart';

class TimeTableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimeTableView();
}

class _TimeTableView extends State<TimeTableView> {
  late TimeTableViewModel viewModel;

  // List week = ['월', '화', '수', '목', '금'];
  // var kColumnLength = 26;
  // double kBoxSize = 40;
  // double kFirstColumnHeight = 40;
  DateTime selectedDate = DateTime.now();
  List<String> list = ['1', '2'];
  late double _deviceWidth, _deviceHeight;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<TimeTableViewModel>(context, listen: true);
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              child: Column(
                children: [
                  // _morningTable(),
                  // _afternoonTable()
                  _createMorningTable(),
                  _setSchedule()
                ],
              ))
      )
    );
  }

  Widget _createMorningTable() {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: DateTime(2000, 1, 1),
      lastDay: DateTime(2049, 12, 31),
      headerStyle: HeaderStyle(titleCentered: true, formatButtonVisible: false),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(color: Colors.transparent),
        weekendDecoration: BoxDecoration(color: Colors.transparent),
        selectedDecoration: BoxDecoration(
          color: ColorData.COLOR_SUBCOLOR1_LIGHT,
          borderRadius: BorderRadius.circular(6),
        ),
        defaultTextStyle: TextStyle(
            fontWeight: FontWeight.w500, color: ColorData.COLOR_SUBCOLOR1),
        weekendTextStyle: TextStyle(
            fontWeight: FontWeight.w500, color: ColorData.COLOR_SUBCOLOR1),
        selectedTextStyle: TextStyle(
            fontWeight: FontWeight.w700, color: ColorData.COLOR_SUBCOLOR1),
      ),
      onDaySelected: (before, after) {
        setState(() {
          selectedDate = after;
        });
      },
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
    );
  }

  Widget _setSchedule() {
    return Expanded(child:
      ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),
            height: 70,
            decoration: BoxDecoration(
                border:
                  Border(bottom: BorderSide(color: ColorData.COLOR_GRAY, width: 1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex:1, child: Container(width: 4, decoration: BoxDecoration(
                  color: ColorData.COLOR_SUBCOLOR1
                  ),
                )),
               Flexible(flex: 3, child: Container(
                 width: _deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('장소', style: TextStyle(
                        color: ColorData.COLOR_SEMIGRAY,
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ),),
                      Text('내용', style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500
                      ))
                    ],
                  ),
                )),
                Flexible(flex: 2, child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('AM 9:00', style: TextStyle(
                        fontSize: 14,
                        color: ColorData.COLOR_SEMIGRAY
                      )),
                      Text('AM 19:00', style: TextStyle(
                        fontSize: 14,
                        color: ColorData.COLOR_GRAY
                      ))
                    ],
                  ),
                ))
              ],
            )

          );
        })
    );
  }

/*  Widget _morningTable() {
    return Container(
      height: 40.5 * 14,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          buildTimeColumn(0),
          ...buildDayColumn(0),
          ...buildDayColumn(1),
          ...buildDayColumn(2),
          ...buildDayColumn(3),
          ...buildDayColumn(4),
        ],
      ),
    );
  }

  Widget _afternoonTable() {
    return Container(
      height: 40.5 * 14,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          buildTimeColumn(13),
          ...buildAfterDayColumn(0),
          ...buildAfterDayColumn(1),
          ...buildAfterDayColumn(2),
          ...buildAfterDayColumn(3),
          ...buildAfterDayColumn(4),
        ],
      ),
    );
  }

  Expanded buildTimeColumn(int startTime) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength,
                (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: kBoxSize,
                child: Center(child: Text('${index ~/ 2 + startTime}:00')),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 2,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                  border: Border.all(color: Colors.black, width: 1)
                ),
              ),
              top: kFirstColumnHeight + kBoxSize / 2,
              height: kBoxSize + kBoxSize * 0.5,
              width: kBoxSize * 1.5,
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> buildAfterDayColumn(int index) {
    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 2,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength,
                      (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.black, width: 1)
                ),
              ),
              top: kFirstColumnHeight + kBoxSize / 2,
              height: kBoxSize + kBoxSize * 0.5,
              width: kBoxSize * 1.5,
            ),
          ],
        ),
      ),
    ];
  }*/
}
