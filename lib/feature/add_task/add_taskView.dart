import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:taskati/feature/home/home_screan.dart';
import 'package:taskati/model/task_model.dart';

import '../../utiles/colors.dart';
import '../../utiles/text_style.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var titleCon = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var noteCon = TextEditingController();
  DateTime _date = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(Duration(minutes: 15)))
      .toString();
  int currentIndex = 0;
  late Box box;
  @override
  void initState() {
    box = Hive.box<Task>('task');

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Add Task',
          style: getSubTitleStyle(),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Title'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: titleCon,
                decoration: InputDecoration(
                    hintText: 'Enter a Text Here',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Title Musn\'t be embty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text('Note'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 5,
                controller: noteCon,
                decoration: InputDecoration(
                  hintText: 'Enter a Note Here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Note Musn\'t be embty';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text('Date'),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          final datePiked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2050),
                              builder: (context, child) {
                                return Theme(
                                  child: child!,
                                  data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                          primary: AppColors.primaryColor,
                                          onPrimary: Colors.white,
                                          onInverseSurface:
                                              AppColors.primaryColor),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryColor,
                                        ),
                                      )),
                                );
                              });
                          if (datePiked != null) {
                            setState(() {
                              _date = datePiked!;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.calendar_month,
                        )),
                    hintText: DateFormat.yMd().format(_date),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('StartTime'),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: _startTime,
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    final datePiked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    if (datePiked != null) {
                                      setState(() {
                                        _startTime = datePiked.format(context);
                                        int plus15Min = datePiked.minute + 15;
                                        _endTime = datePiked
                                            .replacing(minute: plus15Min)
                                            .format(context);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.watch_later_outlined)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('EndTime'),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: _endTime,
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    final datePiked = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now());
                                    if (datePiked != null) {
                                      setState(() {
                                        _endTime = datePiked.format(context);
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.watch_later_outlined)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  selectColor(),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await box.add(Task(
                          id: '${titleCon.text} ${_date.toIso8601String()}',
                            title: titleCon.text,
                            note: noteCon.text,
                            date: _date.toIso8601String(),
                            startTime: _startTime,
                            endTime: _endTime,
                            color: currentIndex,
                            isComplete: false));

                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScrean();
                            },
                          ),
                        );
                      }
                    },
                    child: Container(
                      child: Text(
                        'Create Task',
                        style: getSmallTextStyle(color: Colors.white),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget selectColor() {
    return Container(
        width: 100,
        padding: EdgeInsets.only(top: 20),
        child: Row(
          children: List.generate(3, (index) {
            return Container(
              padding: EdgeInsets.only(right: 3),
              child: InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: CircleAvatar(
                    child: index == currentIndex
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : Container(),
                    radius: 15,
                    backgroundColor: index == 0
                        ? AppColors.primaryColor
                        : index == 1
                            ? AppColors.redColor
                            : AppColors.orangeColor),
              ),
            );
          }),
        ));
  }
}
