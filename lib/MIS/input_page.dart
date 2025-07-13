import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('students').doc(user.uid).set({
        'name': nameController.text,
        'roll_number': rollController.text,
        'semester': int.parse(semesterController.text),
        'selectedSubjects': [],
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Data saved successfully!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Enter Your Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: rollController,
              decoration: InputDecoration(labelText: "Roll Number"),
            ),
            TextField(
              controller: semesterController,
              decoration: InputDecoration(labelText: "Semester"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:(){ saveUserData();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));},
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
