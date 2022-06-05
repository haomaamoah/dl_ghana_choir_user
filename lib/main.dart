// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Database/models.dart';
import 'forms/login_page.dart';
import 'pages/home_page.dart';
import 'Database/file_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ghana Choir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.greenAccent
      ),
      home: //Container()
      FutureBuilder(
        initialData: Expanded(child: Container(color: Colors.green,),),
        future: FileUtils.readFromFile(),
        builder: (context,d){
          Members member = Members();
          bool homepage = false;
          if(d.connectionState == ConnectionState.done && d.hasData){
            List<String> data = d.data.split("|");
            member.pFullName = data[0];member.eFullName = data[1]; member.pGender = data[2];member.eGender = data[3];
            member.pPhone = data[4];member.ePhone = data[5];member.eRelation = data[6];member.password = data[7];
            member.dob = Timestamp.fromMicrosecondsSinceEpoch(int.parse(data[8]));member.location = data[9];member.role = data[10];
            member.section = data[11];member.division = data[12];member.region = data[13];
            member.timestamp = Timestamp.fromMicrosecondsSinceEpoch(int.parse(data[14]));homepage=true;
          }
          return (homepage)? HomePage(member) : LoginForm();


        }
      )
      //PaymentForm(),
      //PaymentPage()
      //HymnsForm()
    );
  }
}




