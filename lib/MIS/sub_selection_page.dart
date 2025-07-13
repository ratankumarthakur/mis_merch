import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubjectSelectionPage extends StatefulWidget {
  @override
  _SubjectSelectionPageState createState() => _SubjectSelectionPageState();
}

class _SubjectSelectionPageState extends State<SubjectSelectionPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Map<String, dynamic>? userData;
  List<dynamic> subjects = [];
  List<Map<String, String>> selectedSubjects = []; // Updated to store objects with id and name.

  String p1 = "", p2 = "",p3="",p4="",p5="";
  String f1 = "0",f2="0",f3="0",f4="0",f5="0";


  @override
  void initState() {
    super.initState();
    fetchUserAndSubjects();
  }

  Future<void> fetchUserAndSubjects() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot =
      await _firestore.collection('students').doc(user!.uid).get();
      setState(() {
        userData = snapshot.data() as Map<String, dynamic>?;
      });

      if (userData != null) {
        int semester = userData!['semester'];
        DocumentSnapshot subjectSnapshot =
        await _firestore.collection('subjects').doc('semester_$semester').get();
        setState(() {
          subjects = subjectSnapshot['subject_list'];
          selectedSubjects = List<Map<String, String>>.from(
              userData!['selectedSubjects']?.map((e) => Map<String, String>.from(e)) ?? []);
        });
      }
    }
  }

  Future<void> selectSubject(String subjectId, String subjectName) async {
    if (!selectedSubjects.any((subject) => subject['id'] == subjectId)) {
      selectedSubjects.add({'id': subjectId, 'name': subjectName});
      await _firestore.collection('students').doc(user!.uid).update({
        'selectedSubjects': selectedSubjects,
      });
      setState(() {});
    }
  }

  Future<void> deselectSubject(String subjectId) async {
    selectedSubjects.removeWhere((subject) => subject['id'] == subjectId);
    await _firestore.collection('students').doc(user!.uid).update({
      'selectedSubjects': selectedSubjects,
    });
    setState(() {
      if (p1 == subjects.firstWhere(
            (subject) => subject['id'] == subjectId,
        orElse: () => null,
      )['name']) {
        p1 = "";
      } else if (p2 == subjects.firstWhere(
            (subject) => subject['id'] == subjectId,
        orElse: () => null,
      )['name']) {
        p2 = "";
      }
      else if (p3 == subjects.firstWhere(
            (subject) => subject['id'] == subjectId,
        orElse: () => null,
      )['name']) {
        p3 = "";
      }
      else if (p4 == subjects.firstWhere(
            (subject) => subject['id'] == subjectId,
        orElse: () => null,
      )['name']) {
        p4 = "";
      }
      else if (p5 == subjects.firstWhere(
            (subject) => subject['id'] == subjectId,
        orElse: () => null,
      )['name']) {
        p5 = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Subject Selection",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue.shade200,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(
              children: [
                Text("Preference 1 :    ",style: TextStyle(fontSize: 18),),
                //if(p1!="")
                  Container(
                    height: 40,width: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                            width: 1,
                            color: Colors.grey
                        ),
                      color: Colors.grey.shade200,
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(p1==""?"Select your preference":"$p1")
                          ,IconButton(
                            onPressed: () {
                              setState(() {
                                f1 = f1 == "0" ? "1" : "0";
                              });
                            },
                            icon: Icon(Icons.arrow_drop_down),
                          ),
                        ],
                      ),
                    ) ,
                  ),
              ],
            ),

            if (f1 == "1")
              Expanded(
                child: subjects.isEmpty
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade200,))
                    : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    String subjectId = subjects[index]['id'];
                    String subjectName = subjects[index]['name'];
                    String branchcode = subjects[index]['offered_by'];
                    bool isDisabled =
                    selectedSubjects.any((subject) => subject['id'] == subjectId);
                    return ListTile(
                      title:  Row(
                        children: [
                          Text(subjectName),
                          SizedBox(width: 10,),
                          Text(branchcode)
                        ],
                      ),
                      trailing: isDisabled && p1 == subjectName
                          ? ElevatedButton(
                        onPressed: () {
                          deselectSubject(subjectId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text("Deselect",style: TextStyle(color: Colors.white),),
                      )
                          : !isDisabled
                          ? ElevatedButton(
                        onPressed: () {
                          selectSubject(subjectId, subjectName);
                          setState(() {
                            if (p1 == "") {
                              p1 = subjectName;
                              f1 = "0";
                            }
                          });
                        },
                        child: Text("Select"),
                      )
                          : null,
                    );
                  },
                ),
              ),


            Row(
              children: [
                const Text("Preference 2 :    ",style: TextStyle(fontSize: 18),),
                //if(p1!="")
                Container(
                  height: 40,width: 400,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          width: 1,
                          color: Colors.grey
                      )
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p2==""?"Select your preference":"$p2")
                        ,IconButton(
                          onPressed: () {
                            setState(() {
                              f2 = f2 == "0" ? "1" : "0";
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ) ,
                ),
              ],
            ),
            if (f2 == "1")
              Expanded(

                child: subjects.isEmpty
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade200,))
                    : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    String subjectId = subjects[index]['id'];
                    String subjectName = subjects[index]['name'];
                    String branchcode = subjects[index]['offered_by'];
                    bool isDisabled =
                    selectedSubjects.any((subject) => subject['id'] == subjectId);
                    return ListTile(
                      title:  Row(
                        children: [
                          Text(subjectName),
                          SizedBox(width: 10,),
                          Text(branchcode)
                        ],
                      ),
                      trailing: isDisabled && p2 == subjectName
                          ? ElevatedButton(
                        onPressed: () {
                          deselectSubject(subjectId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Deselect",style: TextStyle(color: Colors.white),),
                      )
                          : !isDisabled
                          ? ElevatedButton(
                        onPressed: () {
                          selectSubject(subjectId, subjectName);
                          setState(() {
                            if (p2 == "") {
                              p2 = subjectName;
                              f2 = "0";
                            }
                          });
                        },
                        child: const Text("Select"),
                      )
                          : null,
                    );
                  },
                ),
              ),


            Row(
              children: [
                const Text("Preference 3 :    ",style: TextStyle(fontSize: 18),),
                //if(p1!="")
                Container(
                  height: 40,width: 400,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          width: 1,
                          color: Colors.grey
                      )
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p3==""?"Select your preference":"$p3")
                        ,IconButton(
                          onPressed: () {
                            setState(() {
                              f3 = f3 == "0" ? "1" : "0";
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ) ,
                ),
              ],
            ),
            if (f3 == "1")
              Expanded(
                child: subjects.isEmpty
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade200,))
                    : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    String subjectId = subjects[index]['id'];
                    String subjectName = subjects[index]['name'];
                    String branchcode = subjects[index]['offered_by'];
                    bool isDisabled =
                    selectedSubjects.any((subject) => subject['id'] == subjectId);
                    return ListTile(
                      title:  Row(
                        children: [
                          Text(subjectName),
                          SizedBox(width: 10,),
                          Text(branchcode)
                        ],
                      ),
                      trailing: isDisabled && p3 == subjectName
                          ? ElevatedButton(
                        onPressed: () {
                          deselectSubject(subjectId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Deselect",style: TextStyle(color: Colors.white),),
                      )
                          : !isDisabled
                          ? ElevatedButton(
                        onPressed: () {
                          selectSubject(subjectId, subjectName);
                          setState(() {
                            if (p3 == "") {
                              p3 = subjectName;
                              f3 = "0";
                            }
                          });
                        },
                        child: const Text("Select"),
                      )
                          : null,
                    );
                  },
                ),
              ),


            Row(
              children: [
                const Text("Preference 4 :    ",style: TextStyle(fontSize: 18),),
                //if(p1!="")
                Container(
                  height: 40,width: 400,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(
                          width: 1,
                          color: Colors.grey
                      )
                  ),
                  child:Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(p4==""?"Select your preference":"$p4")
                        ,IconButton(
                          onPressed: () {
                            setState(() {
                              f4 = f4 == "0" ? "1" : "0";
                            });
                          },
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                  ) ,
                ),
              ],
            ),
            if (f4 == "1")
              Expanded(
                child: subjects.isEmpty
                    ? Center(child: CircularProgressIndicator(color: Colors.blue.shade200,))
                    : ListView.builder(
                  itemCount: subjects.length,
                  itemBuilder: (context, index) {
                    String subjectId = subjects[index]['id'];
                    String subjectName = subjects[index]['name'];
                    String branchcode = subjects[index]['offered_by'];
                    bool isDisabled =
                    selectedSubjects.any((subject) => subject['id'] == subjectId);
                    return ListTile(
                      title: Row(
                        children: [
                          Text(subjectName),
                          SizedBox(width: 10,),
                          Text(branchcode)
                        ],
                      ),
                      trailing: isDisabled && p4 == subjectName
                          ? ElevatedButton(
                        onPressed: () {
                          deselectSubject(subjectId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text("Deselect",style: TextStyle(color: Colors.white),),
                      )
                          : !isDisabled
                          ? ElevatedButton(
                        onPressed: () {
                          selectSubject(subjectId, subjectName);
                          setState(() {
                            if (p4 == "") {
                              p4 = subjectName;
                              f4 = "0";
                            }
                          });
                        },
                        child: const Text("Select"),
                      )
                          : null,
                    );
                  },
                ),
              ),

            InkWell(
              onTap:() {
                ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Submited successfully!"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
        ),
      );
                Navigator.pushNamed(context, '/home');
              } ,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    color: Colors.blue.shade200
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 38.0,right: 38,top: 5,bottom: 5),
                  child: Text("Submit",style: TextStyle(color: Colors.white),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
