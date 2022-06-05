import 'dart:async';
import '../forms/add_member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Database/cloud_utils.dart';
import '../Database/file_utils.dart';
import '../Database/models.dart';
import 'bouncy_page_route.dart';
import 'accessories.dart';

LogoutDialog(BuildContext context,page){
  String alert =  'Are you sure you want to LOGOUT?';
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(vertical:5.0,horizontal:10.0),
      title: Icon(Icons.login_outlined,size: 60,color: Colors.red,),
      content: Container(width: 50,child: Text(alert,
        textAlign: TextAlign.center,style: TextStyle(fontFamily: "Arial",fontSize: 30,fontWeight: FontWeight.w500),),),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
            ),
                child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: () => Navigator.of(context).pop(false)
                )),
            SizedBox(width: 10,),
            Container(height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.redAccent
            ),
                child:MaterialButton(elevation: 5.0,child: Text('LOGOUT',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: (){
                      FileUtils.deleteFile();
                      Navigator.of(context).pushReplacement(BouncyPageRoute(widget: page));
                    }
                ))
          ],
        )
      ],
    );
  });}

NonUserDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: Icon(Icons.lock,size: 60,color: Colors.red,)),
      content: Text('Login was unsuccessful!'),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });}

NonMemberDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: Icon(Icons.lock,size: 60,color: Colors.red,)),
      content: Text('The number given is not a member!'),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });
}

NoInternetDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.satelliteDish,size: 60,color: Colors.red,)),
      content: Text('Failed! No Internet Connection.'),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text('TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });}

DeleteDialog(BuildContext context){
  String alert = "Are you sure you want to delete?";
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      actionsPadding: EdgeInsets.symmetric(vertical:5.0,horizontal:10.0),
      title: Center(child: Icon(Icons.close,size: 60,color: Colors.red,)),
      content: Container(width: 50,child: Text(alert,
        textAlign: TextAlign.center,style: TextStyle(fontFamily: "Arial",fontSize: 30,fontWeight: FontWeight.w500),),),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 50,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
            ),
                child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: () => Navigator.of(context).pop(false)
                )),
            SizedBox(width: 10,),
            Container(height: 50, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.redAccent
            ),
                child:MaterialButton(elevation: 5.0,child: Text('DELETE',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                    onPressed: () => Navigator.of(context).pop(true)
                ))
          ],
        )
      ],
    );
  });}

StatusDialog(BuildContext context,bool status,String label){
  return showDialog(context: context,builder: (context){
    return AlertDialog(
      title: Center(child: FaIcon((status)?FontAwesomeIcons.checkCircle:Icons.block,size: 60,color: (status)?Colors.green:Colors.red,)),
      content: Text(label,textAlign: TextAlign.center,),
      actions: <Widget>[
        MaterialButton(
          elevation: 5.0,
          child: Text((status)?'OK':'TRY AGAIN',
            style: TextStyle(color: Colors.green,fontSize: 30,fontWeight: FontWeight.w700),
          ),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  });}



memberInfoDialog(BuildContext context,Members member){
  return showDialog(context: context,builder: (context){
    return memberPopUp(member);
  });}
class memberPopUp extends StatefulWidget {
  Members? member;
  memberPopUp(Members member){this.member=member;}

  @override
  _memberPopUpState createState() => _memberPopUpState();
}
class _memberPopUpState extends State<memberPopUp> {
  bool loading = false;
  TextStyle headingStyle = TextStyle(
      fontSize: 17,fontFamily: "Poppins",
      fontWeight: FontWeight.w800
  );
  @override
  Widget build(BuildContext context) {
    Members? member = widget.member;
    DateTime _DOB = member!.dob.toDate(); // Convert TimeStamp to DateTime
    List<String> DOB = _DOB.toString().split('.')[0].split(' '); //Convert DateTime to String
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(FontAwesomeIcons.idCard,size: 17,color: Colors.black,),
          SizedBox(width: 10,),
          Text(
            "MEMBERSHIP INFO",
            style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
          )
        ],
      ),

      content: Stack(
        children: [
          PageView(
            children: [
              ListView(
                children: [
                  SizedBox(height:10),
                  Text(
                    "PERSONAL DETAILS",
                    style: headingStyle,textAlign: TextAlign.center,
                  ),
                  Divider(thickness: 1,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.userAlt,size: 16,color: Colors.blueGrey,),
                      SizedBox(width: 24,),
                      Container(
                        width:120,
                        child: SelectableText(
                          member.pFullName,
                          style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 16,color: Colors.green,),
                      SizedBox(width: 25,),
                      SelectableText(
                        member.pPhone,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 5,),
                      (member.pGender == "MALE")?FaIcon(FontAwesomeIcons.male,size: 16,color: Colors.blue,):FaIcon(FontAwesomeIcons.female,size: 16,color: Colors.pink,),
                      SizedBox(width: 25,),
                      Text(
                        member.pGender,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.calendarAlt,size: 17,color: Colors.black,),
                      SizedBox(width: 22,),
                      Text(
                        "${DOB[0]}",
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.globeAfrica,size: 17,color: Colors.brown,),
                      SizedBox(width: 22,),
                      Text(
                        member.region,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.church,size: 17,color: Colors.green,),
                      SizedBox(width: 22,),
                      Text(
                        member.location,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(Icons.my_location_sharp,size: 17,color: Colors.blue,),
                      SizedBox(width: 22,),
                      Text(
                        member.division,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.userCircle,size: 16,color: Colors.amber,),
                      SizedBox(width: 18,),
                      Text(
                        member.section,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 1,color: Colors.blue,),
                ],
              ),
              ListView(
                children: [
                  SizedBox(height:10),
                  Text(
                    "EMERGENCY CONTACT\nDETAILS",textAlign: TextAlign.center,
                    style: headingStyle,
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.userAlt,size: 16,color: Colors.blueGrey,),
                      SizedBox(width: 10,),
                      Container(
                        width: 120,
                        child: SelectableText(
                          member.eFullName,
                          style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 12,fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 16,color: Colors.green,),
                      SizedBox(width: 10,),
                      SelectableText(
                        member.ePhone,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 12,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 5,),
                      (member.eGender == "MALE")?FaIcon(FontAwesomeIcons.male,size: 16,color: Colors.blue,):FaIcon(FontAwesomeIcons.female,size: 16,color: Colors.pink,),
                      SizedBox(width: 15,),
                      Text(
                        member.eGender,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 12,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 2,color: Colors.black54,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      FaIcon(FontAwesomeIcons.users,size: 15,color: Colors.blueGrey[700],),
                      SizedBox(width: 10,),
                      Text(
                        member.eRelation,
                        style: TextStyle(color: Colors.black,fontFamily: "Times New Roman",fontSize: 13,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Divider(thickness: 1,color: Colors.blue,),
                ],
              ),
            ],
          ),(loading)?Center(child: gradientCirclePBar()):SizedBox()
        ],
      ),
    );
  }
}

class newsInfoDialog extends StatefulWidget {
  News? news;
  newsInfoDialog(News news){this.news=news;}


  @override
  _newsInfoDialogState createState() => _newsInfoDialogState();
}
class _newsInfoDialogState extends State<newsInfoDialog>{
  News? news;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    news = widget.news;
  }

  @override
  Widget build(BuildContext context) {
    String date,time;
    date=news!.timestamp.toDate().toString().split('.')[0].split(' ')[0];
    time=news!.timestamp.toDate().toString().split('.')[0].split(' ')[1];
    return Scaffold(
      appBar: mainAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color:Colors.black,thickness:10),
                  (news!.image!=null)?
                  Hero(
                    tag: "${news!.image}",
                    child: InteractiveViewer(
                      child: FadeInImage.assetNetwork(
                        placeholder: DataUtils.mainLogo,
                        image: news!.image,fit: BoxFit.cover,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.60,
                      )
                    ),
                  ):
                  Hero(tag:"image",child: InteractiveViewer(child: Image.asset(DataUtils.mainLogo,fit: BoxFit.contain,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.3,))),
                  Divider(color:Colors.black,thickness:10),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,color:Colors.green[50],
                            child: SelectableText(news!.heading,
                              textAlign: TextAlign.center,style: TextStyle(fontFamily: "Times New Roman",
                                  fontSize:20.0,fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          Divider(thickness: 0.4,color: Colors.blue),
                          Container(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarAlt,color: Colors.black,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    date,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  SizedBox(width:10),
                                  FaIcon(
                                    FontAwesomeIcons.clock,color: Colors.red,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    time,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.blue),
                          SizedBox(height:10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SelectableText(
                              news!.body,
                              textAlign: TextAlign.start,
                              style: TextStyle(wordSpacing: 1,letterSpacing: 1,
                                fontSize: 18.0,fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),
                          Container(
                            width: double.infinity,
                            color: Colors.red[50],
                            child: SelectableText(
                              news!.footer,
                              style: TextStyle(
                                  fontSize: 17.0,fontFamily:"Poppins",fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),
                        ],
                      )
                  ),

                ],
              )
          ),
        ],
      ),
    );
  }
}


class hymnInfoDialog extends StatefulWidget {
  Hymns? hymn;
  hymnInfoDialog(Hymns hymn){this.hymn=hymn;}


  @override
  _hymnInfoDialogState createState() => _hymnInfoDialogState();
}
class _hymnInfoDialogState extends State<hymnInfoDialog>{
  Hymns? hymn;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    hymn = widget.hymn;
  }

  @override
  Widget build(BuildContext context) {
    String date,time;
    date=hymn!.timestamp.toDate().toString().split('.')[0].split(' ')[0];
    time=hymn!.timestamp.toDate().toString().split('.')[0].split(' ')[1];
    return Scaffold(
      appBar: mainAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color:Colors.black,thickness:10),
                  Hero(tag:"image",child: InteractiveViewer(child: Image.asset(DataUtils.mainLogo,fit: BoxFit.contain,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height * 0.3,))),
                  Divider(color:Colors.black,thickness:10),
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,color:Colors.green[50],
                            child: SelectableText(hymn!.title,
                              textAlign: TextAlign.center,style: TextStyle(fontFamily: "Times New Roman",
                                  fontSize:20.0,fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          Divider(thickness: 0.4,color: Colors.blue),
                          Container(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarAlt,color: Colors.black,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    date,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  SizedBox(width:10),
                                  FaIcon(
                                    FontAwesomeIcons.clock,color: Colors.red,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    time,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.blue),
                          SizedBox(height:10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: SelectableText(
                              hymn!.verses.join("\n"),
                              textAlign: TextAlign.start,
                              style: TextStyle(wordSpacing: 1,letterSpacing: 1,
                                fontSize: 18.0,fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),
                        ],
                      )
                  ),

                ],
              )
          ),
        ],
      ),
    );
  }
}



List<String> genderOpt = DataUtils.genders;
String gender = genderOpt[0];

Future searchGenderDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchGenderPopUp();
  });}
class searchGenderPopUp extends StatefulWidget {
  @override
  _searchGenderPopUpState createState() => _searchGenderPopUpState();
}
class _searchGenderPopUpState extends State<searchGenderPopUp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 0, 20),
          child: DropdownButton(
            dropdownColor: Colors.white,
            value: gender,
            items: genderOpt.map((genderType) {
              return DropdownMenuItem(value: genderType,
                child: Row(children: <Widget>[
                  SizedBox(width: 7,),
                  (genderType=="MALE")?FaIcon(FontAwesomeIcons.male,size: 25,color: Colors.blue,):
                  FaIcon(FontAwesomeIcons.female,size: 25,color: Colors.pinkAccent,),
                  SizedBox(width: 35,),
                  Text(genderType,style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,color: Colors.grey[700],fontWeight: FontWeight.w700),)
                ],),
              );
            }).toList(),
            onChanged: (genderType)=>setState(()=>gender = genderType.toString()),
          )),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(gender)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchDateDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchDatePopUp();
  });}
class searchDatePopUp extends StatefulWidget {
  @override
  _searchDatePopUpState createState() => _searchDatePopUpState();
}
class _searchDatePopUpState extends State<searchDatePopUp> {
  String Date = "SELECT DATE";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.calendarAlt,color: Colors.pinkAccent,size: 26,)),
      content: Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 10, 20),
        child: GestureDetector(
            onTap: () {
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(2021),
                  maxTime: DateTime.now(),
                  onConfirm: (date) {
                    setState(() {
                      Date = date.toString().split(" ")[0];
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Text(Date,textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),
            )
        ),
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(Date)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

OutlineInputBorder infoOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
);

Future searchPhoneDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchPhonePopUp();
  });}
class searchPhonePopUp extends StatefulWidget {
  @override
  _searchPhonePopUpState createState() => _searchPhonePopUpState();
}
class _searchPhonePopUpState extends State<searchPhonePopUp> {
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 27,color: Colors.green,)),
      content: TextFormField(
        controller: phone,keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "PHONE NUMBER",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(phone.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchNameDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchNamePopUp();
  });}
class searchNamePopUp extends StatefulWidget {
  @override
  _searchNamePopUpState createState() => _searchNamePopUpState();
}
class _searchNamePopUpState extends State<searchNamePopUp> {
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.userAlt,color: Colors.blueGrey,size: 27,)),
      content: TextFormField(
        maxLines: 1,
        controller: name,keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "MEMBER'S NAME",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(name.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchRoleDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchRolePopUp();
  });}
class searchRolePopUp extends StatefulWidget {
  @override
  _searchRolePopUpState createState() => _searchRolePopUpState();
}
class _searchRolePopUpState extends State<searchRolePopUp> {
  TextEditingController role = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.userCircle,color: Colors.amber,size: 27,)),
      content: TextFormField(
        maxLines: 1,
        controller: role,keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "MEMBER'S ROLE",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(role.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchLocationDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchLocationPopUp();
  });}
class searchLocationPopUp extends StatefulWidget {
  @override
  _searchLocationPopUpState createState() => _searchLocationPopUpState();
}
class _searchLocationPopUpState extends State<searchLocationPopUp> {
  TextEditingController location = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(Icons.my_location_sharp,color: Colors.amber,size: 27,)),
      content: TextFormField(
        maxLines: 1,
        controller: location,keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "LOCATION",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(location.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchDivisionDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchDivisionPopUp();
  });}
class searchDivisionPopUp extends StatefulWidget {
  @override
  _searchDivisionPopUpState createState() => _searchDivisionPopUpState();
}
class _searchDivisionPopUpState extends State<searchDivisionPopUp> {
  TextEditingController division = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.church,color: Colors.amber,size: 27,)),
      content: TextFormField(
        maxLines: 1,
        controller: division,keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "DIVISION",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(division.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchAmountDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchAmountPopUp();
  });}
class searchAmountPopUp extends StatefulWidget {
  @override
  _searchAmountPopUpState createState() => _searchAmountPopUpState();
}
class _searchAmountPopUpState extends State<searchAmountPopUp> {
  TextEditingController amount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.moneyBillAlt,size: 27,color: Colors.green,)),
      content: TextFormField(
        controller: amount,keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "AMOUNT",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(amount.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}


Future searchTransactIDDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchTransactIDPopUp();
  });}
class searchTransactIDPopUp extends StatefulWidget {
  @override
  _searchTransactIDPopUpState createState() => _searchTransactIDPopUpState();
}
class _searchTransactIDPopUpState extends State<searchTransactIDPopUp> {
  TextEditingController transactID = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.idCard,size: 27,color: Colors.black,)),
      content: TextFormField(
        controller: transactID,keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "TRANSACTION ID",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(transactID.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchBenefactorDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchBenefactorPopUp();
  });}
class searchBenefactorPopUp extends StatefulWidget {
  @override
  _searchBenefactorPopUpState createState() => _searchBenefactorPopUpState();
}
class _searchBenefactorPopUpState extends State<searchBenefactorPopUp> {
  TextEditingController benefactor = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 27,color: Colors.lightBlue,)),
      content: TextFormField(
        controller: benefactor,keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "PHONE NUMBER",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(benefactor.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}


Future searchPurposeDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchPurposePopUp();
  });}

class searchPurposePopUp extends StatefulWidget {
  @override
  _searchPurposePopUpState createState() => _searchPurposePopUpState();
}
class _searchPurposePopUpState extends State<searchPurposePopUp> {
  TextEditingController purpose = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.solidStar,size: 27,color: Colors.amber,)),
      content: TextFormField(
        controller: purpose,keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "PURPOSE",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(purpose.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

Future searchHeadingDialog(BuildContext context){
  return showDialog(context: context,builder: (context){
    return searchHeadingPopUp();
  });}
class searchHeadingPopUp extends StatefulWidget {
  @override
  _searchHeadingPopUpState createState() => _searchHeadingPopUpState();
}
class _searchHeadingPopUpState extends State<searchHeadingPopUp> {
  TextEditingController heading = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: FaIcon(FontAwesomeIcons.heading,size: 27,color: Colors.blueGrey,)),
      content: TextFormField(
        controller: heading,keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: infoOutlineInputBorder,labelText: "HEADING",
        ),
        //validator: validateName,
      ),
      actions: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(height: 30,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.blueAccent
              ),
                  child:MaterialButton(
                      elevation: 5.0,
                      child: Text('SEARCH',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
                      onPressed: ()=>Navigator.of(context).pop(heading.text)
                  )),
              SizedBox(height: 10,),
              Container(height: 30, decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.greenAccent
              ),
                  child:MaterialButton(elevation: 5.0,child: Text('CANCEL',
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),
                  ),
                      onPressed: () => Navigator.of(context).pop()
                  ))
            ],
          ),
        )
      ],
    );
  }
}

class registerInfoDialog extends StatefulWidget {
  Registers? register;
  registerInfoDialog(Registers register){this.register=register;}


  @override
  _registerInfoDialogState createState() => _registerInfoDialogState();
}
class _registerInfoDialogState extends State<registerInfoDialog>{
  Registers? register;
  bool loading = false;
  String? date,time,purpose,location,presentees,absentees;
  Set<dynamic> registerSet = Set();


  Widget RegisterTile(String text1,String text2,String text3,TextStyle style,FaIcon icon1,FaIcon icon2,FaIcon icon3){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon1,
        SizedBox(width: 10,),
        Container(
          child: Text(
            text1,
            style: style,
          ),
        ),
        SizedBox(width:20),
        icon2,
        SizedBox(width: 10,),
        Container(
          child: Text(
            text2,
            style: style,
          ),
        ),
        SizedBox(width:20),
        icon3,
        SizedBox(width: 10,),
        Container(
          child: Text(
            text3,
            style: style,
          ),
        ),
      ],
    );
  }


  String countPeople(String presence,Registers r){
    int count = 0;
    r.register.forEach((attendance){
      if(attendance.endsWith(presence))count++;
    });
    return "$count";
  }

  Widget expectees(){

    Widget memberTile(String text,TextStyle style,FaIcon icon){
      return Row(
        children: [
          icon,
          SizedBox(width: 10,),
          Container(
            width: 120,
            child: SelectableText(
              text,
              style: style,
            ),
          )
        ],
      );
    }

    Set<String> firstLetters = Set();

    register!.register.forEach((attendance){
      firstLetters.add(attendance[0]);
    });
    return Column(
      children: [
        SizedBox(height:10),
        ...firstLetters.map((letter){
          return Column(
            children: [
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.lightBlue[50],
                  ),
                  child: Text(letter,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 13),textAlign: TextAlign.center,)),
              SizedBox(height: 15),
              Divider(color: Colors.red,thickness: 0.3,indent: 15,endIndent: 15,),
              ...register!.register.map(
                      (r){
                    String name = r.split("|")[0];
                    String phone = r.split("|")[1];
                    String present = r.split("|")[2];
                    return (letter == name[0])?
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5.0,
                            child: CheckboxListTile(
                              isThreeLine: true,
                              title: memberTile(name,
                                  TextStyle(fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  FaIcon(FontAwesomeIcons.userAlt,
                                    color: Colors.black, size: 15,)),
                              subtitle: memberTile(phone,
                                  TextStyle(fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                  FaIcon(FontAwesomeIcons.phoneSquareAlt,
                                    color: Colors.green, size: 15,)),
                              onChanged: (bool? value) {},
                              value: (present=="1")?true:false,
                            ),
                          ),
                        ),
                      ],
                    ):SizedBox();
                  }
              ).toList(),
            ],
          );
        }).toList(),
      ],
    );
  }

  void validate()async {
    print('validated');setState(()=>loading=!loading);
    Registers r = Registers.fromMap(register!.toMap());
    Future<void> registerInfo = RegisterDB.updateRegister(r).timeout(const Duration(seconds: 10));
    registerInfo
        .then((value){
      StatusDialog(context, true,"UPDATED SUCCESSFULLY!");
      setState(()=>loading=!loading);
    })
        .catchError((error){
      print("Failed to add register: $error");
      (error.runtimeType == TimeoutException)? NoInternetDialog(context) :
      StatusDialog(context, false,"FAILED TO UPDATE REGISTER!");
      setState(()=>loading=!loading);
    });
  }



  @override
  void initState() {
    super.initState();
    register = widget.register;
    date = register!.date;
    time = register!.time;
    purpose = register!.purpose;
    location = register!.location;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,color:Colors.green[50],
                            child: SelectableText(register!.purpose,
                              textAlign: TextAlign.center,style: TextStyle(fontFamily: "Times New Roman",
                                  fontSize:20.0,fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          SizedBox(height:10),
                          Divider(thickness: 0.4,color: Colors.blue),
                          Container(
                            color: Colors.blue[50],
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.calendarAlt,color: Colors.black,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    date!,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                  SizedBox(width:10),
                                  FaIcon(
                                    FontAwesomeIcons.clock,color: Colors.red,size: 15,
                                  ),
                                  SizedBox(width:10),
                                  SelectableText(
                                    time!,textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,fontFamily: "Times New Roman",fontWeight: FontWeight.w600,fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.blue),
                          SizedBox(height:10),
                          Center(
                            child: RegisterTile(
                                "${register!.register.length}",
                                countPeople("1",register!),
                                countPeople("0",register!),
                                TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                FaIcon(FontAwesomeIcons.users,color: Colors.black54, size: 30,),
                                FaIcon(Icons.check_circle_outline_sharp,color: Colors.green, size: 30,),
                                FaIcon(Icons.cancel_outlined,color: Colors.red, size: 30,)
                            ),
                          ),
                          Divider(thickness:1,color:Colors.black54),
                          SizedBox(height:20),
                          Text("EXPECTED MEMBERS",textAlign: TextAlign.center,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                          expectees(),
                          Divider(thickness: 0.4,color: Colors.red),
                          Container(
                            width: double.infinity,
                            color: Colors.brown[50],
                            child: SelectableText(
                              "LOCATION: ${register!.location}",
                              style: TextStyle(
                                  fontSize: 17.0,fontFamily:"Poppins",fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),
                          Container(
                            width: double.infinity,
                            color: Colors.brown[50],
                            child: SelectableText(
                              "DIVISION: ${register!.division}",
                              style: TextStyle(
                                  fontSize: 17.0,fontFamily:"Poppins",fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),
                          Container(
                            width: double.infinity,
                            color: Colors.brown[50],
                            child: SelectableText(
                              "REGION: ${register!.region}",
                              style: TextStyle(
                                  fontSize: 17.0,fontFamily:"Poppins",fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                          Divider(thickness: 0.4,color: Colors.red),


                        ],
                      )
                  ),

                ],
              )
          ),(loading)?Center(child: gradientCirclePBar()):SizedBox()
        ],
      ),
    );
  }
}
