import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Database/cloud_utils.dart';
import '../Database/models.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';
import 'package:worm_indicator/shape.dart';
import 'package:worm_indicator/worm_indicator.dart';

class MemberForm extends StatefulWidget {
  Members? member;
  MemberForm([Members? member]){this.member = member;}

  @override
  _MemberFormState createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final _formKey = GlobalKey<FormState>();
  PageController pageCtrl = PageController(initialPage: 0);
  bool loading = false;
  Members? member;
  TextEditingController pFullName = TextEditingController();TextEditingController eFullName = TextEditingController();
  TextEditingController pPhone = TextEditingController();TextEditingController ePhone = TextEditingController();
  TextEditingController eRelation = TextEditingController();TextEditingController password = TextEditingController();
  TextEditingController division = TextEditingController();TextEditingController location = TextEditingController();

  late Timestamp dob,timeStamp;


  String _dob_ = "DATE OF BIRTH";

  static List<String> genderOpt = ["SELECT A GENDER",...DataUtils.genders];
  String pGender = genderOpt[0];String eGender = genderOpt[0];

  static List<String> roleOpt = ["SELECT A ROLE",...DataUtils.roles];
  String role = roleOpt[0];

  static List<String> sectionOpt = ["SELECT A SECTION",...DataUtils.sections];
  String section = sectionOpt[0];

  static List<String> regionOpt = ["SELECT A REGION",...DataUtils.regions];
  String region = regionOpt[0];


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
      bool update = (widget.member!=null) ? true : false;
      Members member = Members();
      member.pFullName = pFullName.text;member.eFullName = eFullName.text;
      member.pGender = pGender;member.eGender = eGender;member.role = role;
      member.pPhone = pPhone.text;member.ePhone = ePhone.text;member.section = section;
      member.eRelation = eRelation.text;member.password = password.text;member.region = region;
      member.location = location.text.toUpperCase();member.division=division.text.toUpperCase();
      member.dob = dob;member.timestamp = (update) ? timeStamp : Timestamp.now();

      Future<void> memberInfo = (update) ? MembersDB.updateMember(member):
      MembersDB.addMember(member).timeout(const Duration(seconds: 10));
      memberInfo
          .then((value){
        print("Member ${(update)?'Updated':'Added'}");
        StatusDialog(context, true,"${(update)?'MEMBER UPDATED':'MEMBER ADDED'}\nSUCCESSFULLY!");
        // _formKey.currentState!.reset();
        setState(()=>loading=!loading);
      })
          .catchError((error){
        print("Failed to add member: $error");
        (error.runtimeType == TimeoutException)? NoInternetDialog(context) :
        StatusDialog(context, false,"${(update)?'UPDATE':'MEMBER NOT ADDED:'} FAILED!");
        setState(()=>loading=!loading);
      });
    }

  }

  String? validateName(name){
    if (name.isEmpty) {
      return 'Name is required';
    } else{
      return null;
    }
  }

  // Personal Full Name
  Widget _pFullName(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: pFullName,
          decoration: InputDecoration(
            border: infoOutlineInputBorder,labelText: "FULL NAME",icon: FaIcon(FontAwesomeIcons.userAlt,color: Colors.blueGrey,)),
          validator: validateName,
        ),
      ),
    );
  }
  // Emergency Full Name
  Widget _eFullName(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: eFullName,
          decoration: InputDecoration(
            border: infoOutlineInputBorder,labelText: "FULL NAME",icon: FaIcon(FontAwesomeIcons.userAlt,color: Colors.blueGrey,)),
          validator: validateName,
        ),
      ),
    );
  }
  // Location
  Widget _location(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: location,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "LOCATION",icon: FaIcon(FontAwesomeIcons.church,color: Colors.green,size: 28,)
          ),
          validator: validateName,
        ),
      ),
    );
  }
  // Personal Phone
  Widget _pPhone(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          keyboardType: TextInputType.phone,
          controller: pPhone,
          decoration: InputDecoration(
            border: infoOutlineInputBorder,labelText: "PHONE NUMBER",icon: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 27,color: Colors.green,)
          ),
          validator: validateName,
        ),
      ),
    );
  }
  // Emergency Phone
  Widget _ePhone(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: ePhone,keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            border: infoOutlineInputBorder,labelText: "PHONE NUMBER",icon: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 27,color: Colors.green,)
          ),
          validator: validateName,
        ),
      ),
    );
  }

  // Emergency Relation
  Widget _eRelation(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: eRelation,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "RELATION",icon: FaIcon(FontAwesomeIcons.users,color: Colors.blueGrey[700],size: 20,)),
          validator: validateName,
        ),
      ),
    );
  }

  // Personal Password
  Widget _pPassword(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: password,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "PASSWORD",icon: FaIcon(Icons.lock,color: Colors.red,size: 28,)
          ),
          validator: validateName,
        ),
      ),
    );
  }

  // Division
  Widget _division(){
    return Container(
      height: 100,
      child: Padding(
        padding: infoPadding,
        child: TextFormField(
          controller: division,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              border: infoOutlineInputBorder,labelText: "DIVISION",icon: FaIcon(Icons.my_location_sharp,color: Colors.blue,size: 28,)
          ),
          validator: validateName,
        ),
      ),
    );
  }
  Widget _pGender(){
    return Container(
        padding: infoPadding,
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: pGender,
          items: genderOpt.map((genderType) {
            return DropdownMenuItem(value: genderType,
              child: Row(children: <Widget>[
                SizedBox(width: 20,),
                (genderType=="SELECT A GENDER")?SizedBox():
                ((genderType=="MALE")?FaIcon(FontAwesomeIcons.male,size: 25,color: Colors.blue,):
                FaIcon(FontAwesomeIcons.female,size: 25,color: Colors.pinkAccent,)),
                SizedBox(width: 35,),
                Text(genderType,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
              ],),
            );
          }).toList(),
          onChanged: (genderType)=>setState(()=>pGender = genderType.toString()),
        ));
  }
  Widget _eGender(){
    return Container(
        padding: infoPadding,
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: eGender,
          items: genderOpt.map((genderType) {
            return DropdownMenuItem(value: genderType,
              child: Row(children: <Widget>[
                SizedBox(width: 20,),
                (genderType=="SELECT A GENDER")?SizedBox():
                ((genderType=="MALE")?FaIcon(FontAwesomeIcons.male,size: 25,color: Colors.blue,):
                FaIcon(FontAwesomeIcons.female,size: 25,color: Colors.pinkAccent,)),
                SizedBox(width: 35,),
                Text(genderType,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
              ],),
            );
          }).toList(),
          onChanged: (genderType)=>setState(()=>eGender = genderType.toString()),
        ));
  }
  // Region
  Widget _region(){
    return Container(
        padding: infoPadding,
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: region,
          items: regionOpt.map((regionName) {
            return DropdownMenuItem(value: regionName,
              child: Row(children: <Widget>[
                if(regionName!="SELECT A REGION")FaIcon(FontAwesomeIcons.globeAfrica,size: 25,color: Colors.brown,),
                SizedBox(width: 20,),
                Text(regionName,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
              ],),
            );
          }).toList(),
          onChanged: (regionName)=>setState(()=>region = regionName.toString()),
        ));
  }
  // Role
  Widget _role(){
    return Container(
        padding: infoPadding,
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: role,
          items: roleOpt.map((roleName) {
            return DropdownMenuItem(value: roleName,
              child: Row(children: <Widget>[
                if(roleName!="SELECT A ROLE")FaIcon(FontAwesomeIcons.music,size: 25,color: Colors.blueGrey,),
                SizedBox(width: 20,),
                Text(roleName,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
              ],),
            );
          }).toList(),
          onChanged: (roleName)=>setState(()=>role = roleName.toString()),
        ));  }
  // Section
  Widget _section(){
    return Container(
        padding: infoPadding,
        child: DropdownButton(
          dropdownColor: Colors.white,
          value: section,
          items: sectionOpt.map((sectionName) {
            return DropdownMenuItem(value: sectionName,
              child: Row(children: <Widget>[
                if(sectionName!="SELECT A SECTION")FaIcon(FontAwesomeIcons.users,size: 25,color: Colors.black,),
                SizedBox(width: 20,),
                Text(sectionName,style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
              ],),
            );
          }).toList(),
          onChanged: (sectionName)=>setState(()=>section = sectionName.toString()),
        ));  }





  //Personal Date Of Birth
  Widget _pDOB(){
    return Padding(
      padding: infoPadding,
      child: GestureDetector(
          onTap: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                minTime: DateTime(1940, 1, 1),
                maxTime: DateTime(2020, 1, 1), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  setState(() {
                    dob = Timestamp.fromDate(date);
                    _dob_ = dob.toDate().toString().split(" ")[0];
                  });
                }, currentTime: DateTime(2000), locale: LocaleType.en);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.calendar_today_rounded,color: Colors.black,size: 26,),
              SizedBox(width: 25,),
              Container(
                child: Text(_dob_,
                  style: TextStyle(
                      fontSize: 17,color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic
                  ),
                ),
              )

            ],
          )
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    member = widget.member;
    if(member!=null){
      pFullName.text = member!.pFullName;
      eFullName.text = member!.eFullName;
      pPhone.text = member!.pPhone;
      ePhone.text = member!.ePhone;
      pGender = member!.pGender;
      eGender = member!.eGender;
      location.text = member!.location;
      region = member!.region;
      division.text = member!.division;
      section = member!.section;
      dob = member!.dob;
      _dob_ = dob.toDate().toString().split(" ")[0];
      eRelation.text = member!.eRelation;
      role = member!.role;
      password.text = member!.password;
      timeStamp = member!.timestamp;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: PageView(
              controller: pageCtrl,
              children: [
                ListView(
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        "PERSONAL DETAILS",
                        style: headingStyle,
                      ),
                    ),
                    Divider(thickness: 1,color: Colors.black,indent: 35,endIndent: 35,),
                    _pFullName(), _pPhone(), _pPassword(), _pDOB(), _pGender(),
                    _section(), _role(),_region(), _division(), _location(),


                    Divider(),
                  ]
                ),
                ListView(
                  children: [
                    SizedBox(height: 20,),
                    Center(
                      child: Text(
                        "EMERGENCY CONTACT\nDETAILS",
                        style: headingStyle,textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(thickness: 1,color: Colors.black,indent: 35,endIndent: 35,),
                    _eFullName(),
                    _ePhone(),
                    _eGender(),
                    _eRelation(),
                    Divider(),
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
                    SizedBox(height:50)

                  ]
                ),
              ],
            ),
          ),(loading)?Center(child: gradientCirclePBar()):SizedBox(),
          Align(
              alignment: Alignment.bottomCenter,
              child:Container(
                width:double.infinity,
                color: Colors.white,
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: WormIndicator(
                    length: 2,
                    color: Colors.red,
                    indicatorColor: Colors.green,
                    controller: pageCtrl,
                    shape: Shape(
                        size: 15,
                        spacing: 8,
                        shape: DotShape.Circle  // Similar for Square
                    ),
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
