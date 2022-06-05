
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Database/cloud_utils.dart';
import '../Database/models.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';

class RegisterPage extends StatefulWidget {
  Registers? register;
  RegisterPage([Registers? register]){this.register = register;}

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  dynamic Stream = RegisterDB.getAllRegister();
  Widget NewsTile(String text,TextStyle style,FaIcon icon){
    return Row(
      children: [
        icon,
        SizedBox(width: 10,),
        Expanded(
          child: Text(
            text,
            style: style,
          ),
        )
      ],
    );
  }
  Widget RegisterTile(String text1,String text2,String text3,TextStyle style,FaIcon icon1,FaIcon icon2,FaIcon icon3){
    return Row(
      children: [
        icon1,
        SizedBox(width: 8,),
        Container(
          child: Text(
            text1,
            style: style,
          ),
        ),
        SizedBox(width:12),
        icon2,
        SizedBox(width: 8,),
        Container(
          child: Text(
            text2,
            style: style,
          ),
        ),
        SizedBox(width:12),
        icon3,
        SizedBox(width: 8,),
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

  bool list_by_location=false;

  void listByDate()=>setState(()=>list_by_location=false);

  void listByLocation()=>setState(()=>list_by_location=true);

  void sPurpose()=>searchPurposeDialog(context).then((purpose)=>setState(()=>Stream=RegisterDB.searchPurpose(purpose.toString().toUpperCase())));

  void sLocation()=>searchLocationDialog(context).then((location)=>setState(()=>Stream=RegisterDB.searchLocation(location.toString().toUpperCase())));

  void sDate()=>searchDateDialog(context).then((date)=>setState(()=>Stream=RegisterDB.searchDate(date)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: registerSearchButton(listByDate,listByLocation,sDate,sLocation,sPurpose),
      body: Container(
        color: Colors.white60,
        child: StreamBuilder(
          stream: Stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> r) {
            Set _dates = Set();List dates = [];int docLength=(r.hasData)?r.data!.docs.length:0;
            if(list_by_location){
              for(int x=0;x<docLength;x++) {
                _dates.add(r.data!.docs[x]["location"]);
                dates = List.from(_dates);dates.sort();
              }}
            else{
              for(int x=0;x<docLength;x++){
                _dates.add(r.data!.docs[x]["date"]);
                dates = List.from(_dates);
              }
            }


            return (r.connectionState == ConnectionState.waiting) ? Center(child: gradientCirclePBar()) :
            ((docLength==0) ? Center(child: Text("No records available")):
            ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height:10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.users,color: Colors.black),
                        SizedBox(width:10),
                        Text("$docLength",style: TextStyle(fontFamily:"Times New Roman",color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                      ],
                    ),
                    ...dates.map((date){
                      return Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.lightBlue[100],
                              ),
                              child: Text(date,style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold,fontSize: 13),textAlign: TextAlign.center,)),
                          SizedBox(height: 15),
                          Divider(color: Colors.red,thickness: 0.3,indent: 5,endIndent: 5),
                          ...r.data!.docs.map(
                                  (r){
                                    Registers register = Registers.fromMap(r.data() as Map<String,dynamic>);
                                    return ((list_by_location) ? date == register.location : date == register.date) ?
                                    GestureDetector(
                                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder:(context)=>registerInfoDialog(register))),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Card(
                                              elevation: 5.0,
                                              child: ListTile(
                                                isThreeLine: true,
                                                title: NewsTile(register.purpose,
                                                    TextStyle(fontSize: 14,fontFamily: "Times New Roman",
                                                        fontWeight: FontWeight.w600),
                                                    FaIcon(FontAwesomeIcons.solidStar,
                                                      color: Colors.amber, size: 15,)),
                                                subtitle: RegisterTile(
                                                    "${register.register.length}",
                                                    countPeople("1",register),
                                                    countPeople("0",register),
                                                    TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                                    FaIcon(FontAwesomeIcons.users,color: Colors.black54, size: 15,),
                                                    FaIcon(Icons.check_circle_outline_sharp,color: Colors.green, size: 15,),
                                                    FaIcon(Icons.cancel_outlined,color: Colors.red, size: 15,)
                                                ),
                                                leading: Image.asset(DataUtils.mainLogoRound,fit: BoxFit.cover,width: 35,height: 35,),
                                                trailing: Column(
                                                  children: [
                                                    Text(register.date,style: TextStyle(fontSize: 10,
                                                        fontWeight: FontWeight.w500),),
                                                    Text(register.time.substring(0,5),style: TextStyle(fontSize: 10,
                                                        fontWeight: FontWeight.w500),),
                                                    Container(
                                                      width:50,
                                                      child: Text(register.region,textAlign: TextAlign.center,style: TextStyle(fontSize: 10,
                                                          fontWeight: FontWeight.w500,),),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ):SizedBox();
                              }
                          ).toList(),
                        ],
                      );
                    }).toList(),
                    SizedBox(height:40)
                  ],
                ),
              ],
            ));
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
