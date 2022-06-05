import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Database/cloud_utils.dart';
import '../Database/file_utils.dart';
import '../pages/home_page.dart';
import '../widgets/bouncy_page_route.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin{

  final _formKey = GlobalKey<FormState>();
  AnimationController? rotationController;

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  TextStyle headingStyle = TextStyle(decoration: TextDecoration.underline, fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600);
  EdgeInsets infoPadding = EdgeInsets.only(top: 2.0,bottom: 2.0,left:2.0,right: 2.0);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(20),);


  void validate(){
    if (_formKey.currentState!.validate()){
      //
      //   try {
      //     MembersDB.validMember(phone.text).timeout(const Duration(seconds: 10))
      //         .then((_memberInfo){
      //       QueryDocumentSnapshot memberInfo = _memberInfo.docs[0];
      //       if(memberInfo.exists){
      //         print(memberInfo["password"]);
      //         if(memberInfo["password"]!=password.text){
      //           NonUserDialog(context);
      //         }else {
      //           Members member = Members.fromMap(memberInfo.data());
      //           FileUtils.saveToFile("${member.pFullName}|${member.eFullName}|${member.bFullName}|${member.pGender}|${member.eGender}|${member.bGender}|${member.pPhone}|${member.ePhone}|${member.bPhone}|${member.eRelation}|${member.bRelation}|${member.password}|${member.pDOB!.microsecondsSinceEpoch}|${member.eDOB!.microsecondsSinceEpoch}|${member.bDOB!.microsecondsSinceEpoch}|${member.pYG}|${member.house}|${member.timestamp!.microsecondsSinceEpoch}");
      //           Navigator.pushReplacement(context, BouncyPageRoute(widget: HomePage(member)));
      //         }
      //       }else{
      //         NonUserDialog(context);
      //       }
      //     })
      //         .catchError((error){
      //       if (error==TimeoutException){NoInternetDialog(context);}
      //       else{NonUserDialog(context);}
      //     });
      //   } on Error catch (e) {
      //     print('Error: $e');
      //   }
      //
      // } else{
      //   print('not valid');
      // }
      //
      // setState(()=>loading=!loading);


      MembersDB.validMember(phone.text).timeout(const Duration(seconds: 10))
          .then((_memberInfo){
        QueryDocumentSnapshot memberInfo = _memberInfo.docs[0];
        if(memberInfo.exists){
          if(memberInfo["password"]!=password.text){
            NonUserDialog(context);setState(()=>loading=!loading);
          }else {
            Members member = Members.fromMap(memberInfo.data());

            FileUtils.saveToFile(
                "${member.pFullName}|${member.eFullName}|${member.pGender}|${member.eGender}|"
                "${member.pPhone}|${member.ePhone}|${member.eRelation}|"
                "${member.password}|${member.dob.microsecondsSinceEpoch}|"
                "${member.location}|${member.role}|${member.section}|"
                "${member.division}|${member.region}|${member.timestamp.microsecondsSinceEpoch}");
            Navigator.pushReplacement(context, BouncyPageRoute(widget: HomePage(member)));
          }
        }else{
          NonUserDialog(context);setState(()=>loading=!loading);
        }
      })
          .catchError((error){
        if (error==TimeoutException){NoInternetDialog(context);setState(()=>loading=!loading);}
        else{NonUserDialog(context);setState(()=>loading=!loading);}
      });



    } else{
      print('not valid');
    }

    // setState(()=>loading=!loading);
  }

  String? validateName(name){
    if (name.isEmpty) {
      return 'Name is required';
    } else{
      return null;
    }
  }


  // Phone Field
  Widget phoneNum(){
    return TextFormField(
      controller: phone,keyboardType: TextInputType.phone,
      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w700),
        hintText: "PHONE NUMBER",icon: FaIcon(FontAwesomeIcons.phoneSquareAlt,color: Colors.green[700],),
      ),
      validator: validateName,
    );
  }


  // passWord Field
  Widget passWord(){
    return TextFormField(
      controller: password,obscureText: true,
      decoration: InputDecoration(hintStyle: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.w700),
        hintText: "ENTER PASSWORD",icon: FaIcon(FontAwesomeIcons.lock,color: Colors.red,),
      ),
      validator: validateName,
    );
  }

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 10));
    rotationController!.repeat();
  }

  @override
  void dispose() {
    rotationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> SystemNavigator.pop() as Future<bool>,
      child: Material(child: Stack(children:[
        Center(
            child:Container(
              color:Colors.white,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  AnimatedBuilder(
                      animation: rotationController!,
                      builder: (BuildContext context,widget){
                        return Transform.rotate(angle: rotationController!.value*6.3,child: widget,);
                      },
                      child:FadeAnimation(5,Curves.easeInBack,CircleAvatar(maxRadius: 100,backgroundColor: Colors.transparent,
                        child: Image.asset(DataUtils.mainLogo,
                          height: 150,width:150,
                          fit: BoxFit.cover,),
                      ))),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 40, 60, 40),
                          child: FadeAnimation(3,Curves.fastOutSlowIn,Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(10, 5,5, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(
                                  color: Colors.red,blurRadius: 5,offset: Offset(0,2)
                              ),],
                            ),
                            child: phoneNum(),
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 40, 60, 40),
                          child: FadeAnimation(3,Curves.fastOutSlowIn,Container(
                            height: 50,
                            padding: EdgeInsets.fromLTRB(10, 5,5, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [BoxShadow(
                                  color: Colors.red,blurRadius: 5,offset: Offset(0,2)
                              ),],
                            ),
                            child: passWord(),
                          )),
                        ),
                      ],
                    ),
                  ),
                  FadeAnimation(3,Curves.bounceInOut,Center(
                    child: GestureDetector(
                      onTap: ()async{
                        setState(()=>loading=!loading);
                        validate();
                        // if (!RegExp(r"^\d{1,5}$").hasMatch(password.text)){NonUserDialog(context);}
                        // else{
                        //   setState(()=>loading=!loading);
                        //   validate();
                        // }
                      },
                      child: Container(
                        width: 150,height: 50,
                        padding: EdgeInsets.fromLTRB(40, 10, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.green[900],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text('LOGIN',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,fontSize: 25),),
                      ),
                    ),
                  )),
                  SizedBox(height: 20.0,),
                  Text('Powered by Noble IT Solutions\n©2021',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54,
                        fontFamily: "Times New Roman",
                        fontWeight: FontWeight.w900,
                        fontSize: 14.0),),
                ],
              ),
            )),(loading)?Center(child: gradientCirclePBar()):SizedBox()])),
    );
  }
}
