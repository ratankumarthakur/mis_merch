import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google/MIS/sub_selection_page.dart';
import 'package:http/http.dart' as http;
import 'MIS/home_page.dart';
import 'MIS/login_page.dart';
import 'MERCH/merch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    
    options:const FirebaseOptions(

  // for merchendise // name: "test1", //firebase : ecommerce
      // apiKey: "",
      // appId: "",
      // messagingSenderId:"",
      // projectId: "",
      // storageBucket: ''),

// for MIS //firebase : alumnidekho
     apiKey: "",
     appId: "",
     messagingSenderId:"",
     projectId: "",)

  );  // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google',
      debugShowCheckedModeBanner: false,
      //for mis
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/subject_selection':(context)=> SubjectSelectionPage(),
      },

      //for merch directly use 
      //home:merch(),
      //and don;t write routes,initial routes

      //for MIS
      //home:HomePage(),under routes
    );
  }
}
