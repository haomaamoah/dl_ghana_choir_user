import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import '../Database/cloud_utils.dart';
import '../Database/models.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';

class PasswordForm extends StatefulWidget {
  Members? member;
  PasswordForm(Members? member){this.member = member;}

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Members? member;
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();



  TextStyle headingStyle = TextStyle(
      fontSize: 20,fontFamily: "Poppins",
      fontWeight: FontWeight.w800
  );

  EdgeInsets infoPadding = EdgeInsets.fromLTRB(35, 20, 35, 20);
  OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  void validate()async {
    if (_formKey.currentState!.validate()){
      print('validated');setState(()=>loading=!loading);
      member!.password = newPassword.text;
      MembersDB.updatePassword(member!).timeout(const Duration(seconds: 10))
          .then((value){
        print("Password Updated");
        StatusDialog(context, true,"PASSWORD UPDATED!");
        _formKey.currentState!.reset();
        setState(()=>loading=!loading);
      })
          .catchError((error){
        print("Failed to add member: $error");
        (error.runtimeType == TimeoutException)? NoInternetDialog(context) :
        StatusDialog(context, false,"UPDATE FAILED!");
        setState(()=>loading=!loading);
      });
    }

  }

  String? validateOldPass(password){
    if (password.isEmpty) {
      return 'Old password is required';
    }
    else if(password!=member!.password) {
      return 'Password is INVALID! Try Again.';
    } else{
      return null;
    }
  }

  String? validateNewPass(password){
    if (password.isEmpty) {
      return 'New password is required';
    }
    else if(newPassword.text!=confirmPassword.text) {
      return 'Passwords do not match. Try Again.';
    } else{
      return null;
    }
  }


  // Personal Full Name
  Widget _oldPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: oldPassword,
          obscureText: true, keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "OLD PASSWORD"),
          validator: validateOldPass,
        ),
      ),
    );
  }

  // Personal Phone
  Widget _newPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          obscureText: true, keyboardType: TextInputType.text,
          controller: newPassword,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "NEW PASSWORD"
          ),
          validator: validateNewPass,
        ),
      ),
    );
  }

  // Personal Password
  Widget _confirmPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: confirmPassword,
          obscureText: true, keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "CONFIRM NEW PASSWORD"
          ),
          validator: validateNewPass,
        ),
      ),
    );
  }



  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    member = widget.member;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
                children: [
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      "CHANGE PASSWORD",
                      style: headingStyle,
                    ),
                  ),
                  Divider(thickness: 1,color: Colors.black,indent: 35,endIndent: 35,),
                  _oldPassword(),
                  _newPassword(),
                  _confirmPassword(),
                  Divider(),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.fromLTRB(35, 0, 35, 0),
                    child: Container(height: 35, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
                    ),
                        child:MaterialButton(elevation: 5.0,child: Text("SUBMIT",
                          style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
                        ),
                            onPressed: validate
                        )),
                  ),
                  SizedBox(
                    height: 40,
                  )
                ]
            ),
          ),(loading)?Center(child: gradientCirclePBar()):SizedBox(),
        ],
      ),
    );
  }
}
