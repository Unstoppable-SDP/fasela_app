import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PlantCondition extends StatefulWidget {
  const PlantCondition({super.key});

  @override
  State<PlantCondition> createState() => _PlantConditionState();
}

class _PlantConditionState extends State<PlantCondition> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("test"),
    );
  }
}
