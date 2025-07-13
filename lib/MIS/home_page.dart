import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
          await _firestore.collection('students').doc(user!.uid).get();
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>?;
      });
    }
  }

  Future<void> updateSemester(int newSemester) async {
    if (user != null) {
      await _firestore
          .collection('students')
          .doc(user!.uid)
          .update({'semester': newSemester});
      setState(() {
        userData?['semester'] = newSemester;
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController semesterController = TextEditingController();

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .set({
        'name': nameController.text,
        'roll_number': rollController.text,
        'semester': int.parse(semesterController.text),
        'selectedSubjects': [],
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Data saved successfully!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userData == null) {
      return Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          title: Text(
            "Enter Your Details",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue.shade200,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: 400,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", border: OutlineInputBorder()),
                ),
              ),
              Container(
                height: 70,
                width: 400,
                child: TextField(
                  controller: rollController,
                  decoration: InputDecoration(
                      labelText: "Roll Number", border: OutlineInputBorder()),
                ),
              ),
              Container(
                height: 70,
                width: 400,
                child: TextField(
                  controller: semesterController,
                  decoration: InputDecoration(
                      labelText: "Semester", border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  saveUserData();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: Colors.blue.shade200),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 48.0, right: 48, top: 10, bottom: 10),
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>InputPage()));
    }
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        title: Text("Profile page", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade200,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Name : ${userData!['name']}",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Roll Number: ${userData!['roll_number']}",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Semester: ${userData!['semester']}",
                  style: TextStyle(fontSize: 18),
                ),
                InkWell(
                  onTap: () =>
                      Navigator.pushNamed(context, '/subject_selection'),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.blue.shade200),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 38.0, right: 38, top: 5, bottom: 5),
                      child: Text(
                        "Select Subjects",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => updateSemester(userData!['semester'] + 1),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.blue.shade200),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 38.0, right: 38, top: 5, bottom: 5),
                      child: Text(
                        "Update Semester",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.network(
                      "https://t3.ftcdn.net/jpg/02/43/12/34/360_F_243123463_zTooub557xEWABDLk0jJklDyLSGl2jrr.jpg",
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ))
                // SizedBox(height: 10,),
                // SizedBox(height: 10,),
                // SizedBox(height: 10,),
                // SizedBox(height: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
