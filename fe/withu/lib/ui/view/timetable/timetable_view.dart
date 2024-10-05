import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withu/ui/viewmodel/timetable/timetable_viewmodel.dart';

class TimeTableView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimeTableView();
}

class _TimeTableView extends State<TimeTableView> {
  late TimeTableViewModel viewModel;
  List week = ['월', '화', '수', '목', '금'];
  var kColumnLength = 26;
  double kBoxSize = 40;
  double kFirstColumnHeight = 40;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<TimeTableViewModel>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _morningTable(),
            _afternoonTable()
          ],
        ),
      ),
    );
  }

  Widget _morningTable() {
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
  }

}