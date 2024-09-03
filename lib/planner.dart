import 'dart:io';

import 'package:flutter/material.dart';
import 'package:total_running/activity.dart';
import 'package:file_picker/file_picker.dart';

class Planner extends StatefulWidget{
  const Planner({super.key});

  @override
  State<Planner> createState() => _PlannerState();
}

class _PlannerState extends State<Planner>{
  List<DateTime> getCurrentWeekDates() {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));

    List<DateTime> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(monday.add(Duration(days: i)));
    }

    return weekDates;
  }

  String getMonthDay(DateTime date) {
    return '${date.month}/${date.day}';
  }

  static const Widget headerRow = Padding(
    padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Date', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Text('Description', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Text('Mileage', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  static const Widget summaryHeaderRow = Padding(padding: EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Summary', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Text('Total Mileage', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  int getActivityId(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  void launchActivity(DateTime date){
    Navigator.push(context, MaterialPageRoute(builder: (context) => Activity(date: date, id: getActivityId(date))));
  }
  
  void uploadActivityFile(DateTime date) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      // Add file details to log/DB/activity it's related to
    } else {
      // User canceled the picker
    }
  }

  Widget summaryRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex:3,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: TextFormField(
                maxLines: null,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            )
          ),
          const SizedBox(width: 16),
          Flexible(
            flex:1,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ),
            child: TextFormField(
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogRow(DateTime date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: 
                Column(children: [
                  TextButton(child: Text(getMonthDay(date)), onPressed: () => launchActivity(date)),
                  IconButton(icon: const Icon(Icons.upload_file), onPressed: () => uploadActivityFile(date))
                ])
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 4,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                ),
                child: TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )
              )
            ),
            const SizedBox(width: 16),
            Flexible(
              flex: 1,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey)
                ),
                child: TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
            ),
          ],
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    var weekDates = getCurrentWeekDates();
    assert(weekDates.length == 7);
    return Scaffold(
      appBar: AppBar(
        // TODO: Change to <This User's Name>'s Log
        title: const Text('Your Log'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            headerRow,
            Form(child: Column(
              children: [
                buildLogRow(weekDates[0]),
                buildLogRow(weekDates[1]),
                buildLogRow(weekDates[2]),
                buildLogRow(weekDates[3]),
                buildLogRow(weekDates[4]),
                buildLogRow(weekDates[5]),
                buildLogRow(weekDates[6]),
                summaryHeaderRow,
                summaryRow(),
              ],
            )),
          ],
        ),
      ),
    );
  }
}