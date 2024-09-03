
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class TrainingLoad{
  final int section;
  const TrainingLoad({
    required this.section
  });

  factory TrainingLoad.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'trainingLoad': int section,
      } =>
        TrainingLoad(
          section: section
        ),
      _ => throw const FormatException('Failed to load run prediction.'),
    };
  }
}

class _ProfileState extends State<Profile>{
  Future<http.Response> fetchTrainingLoad(){
    return http.get(Uri.parse('10.0.0.71/raspberrypi/training_load'));
  }



  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile'),
      ),
      
    );
  }
}