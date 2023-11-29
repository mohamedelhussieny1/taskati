import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:taskati/feature/home/widget/empty_task.dart';
import 'package:taskati/feature/home/widget/home_header.dart';
import 'package:taskati/feature/home/widget/list_task_widget.dart';
import 'package:taskati/model/task_model.dart';

import '../../utiles/colors.dart';
import '../../utiles/text_style.dart';
import '../add_task/add_taskView.dart';

class HomeScrean extends StatefulWidget {
  const HomeScrean({super.key});

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> {
  DateTime? _selectedValue = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        HomeHeader(),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.MMMEd().format(DateTime.now()),
                    style: getTitleStyle()),
                SizedBox(
                  height: 5,
                ),
                Text('Today', style: getSmallTextStyle()),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return AddTask();
                  },
                ));
              },
              child: Container(
                height: 50,
                width: 100,
                child: Center(
                    child: Text(
                  '+ addTask',
                  style: getSmallTextStyle(color: Colors.white),
                )),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        DatePicker(
          height: 100,
          width: 80,
          DateTime.now(),
          initialSelectedDate: _selectedValue,
          selectionColor: AppColors.primaryColor,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            // New date selected
            setState(() {
              _selectedValue = date;
            });
          },
        ),
        ValueListenableBuilder(
          valueListenable: Hive.box<Task>('task').listenable(),
          builder: (BuildContext context, Box<Task> value, Widget? child) {
            List<Task> tasks = value.values.where((element) {
              if (element.date.split('T').first ==
                  _selectedValue!.toIso8601String().split('T').first) {
                return true;
              } else {
                return false;
              }
            }).toList();

            if (tasks.isEmpty) {
              return const EmptyTaskWidget();
            } else {
              return TaskListWidget(tasks: tasks, value: value);
            }
          },
        )
      ]),
    )));
  }
}
