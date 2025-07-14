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

  // for merchendise // name: "test1",
      // apiKey: "AIzaSyDOYTB5MCy_VKeDlzcS8DThcMk7eYfSl6I",
      // appId: "1:39721889660:android:2e9987b4afa2e1c45f7ef9",
      // messagingSenderId:"39721889660",
      // projectId: "ecommerce-eb54d",
      // storageBucket: 'ecommerce-eb54d.appspot.com'),

// for MIS
     apiKey: "AIzaSyCsLkA2-oUJFaCW7kA5tkMuqemDPfS9INw",
     appId: "1:816540763282:android:234b28664f8b0d2622d24b",
     messagingSenderId:"816540763282",
     projectId: "alumnidekho-2fd65",)

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
