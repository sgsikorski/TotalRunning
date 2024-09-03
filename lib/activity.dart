import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Activity extends StatelessWidget{
  const Activity({super.key, required this.date, required this.id});
  final DateTime date;
  final int id;


  @override
  Widget build(BuildContext){
    Request request = Request('GET', Uri.parse('https://10.0.0.71:5000/training_load?id=${this.id}'));
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity'),
      ),
      body: Center(
        child: Text('Activity for ${date}'),
      ),
    );
  }
}