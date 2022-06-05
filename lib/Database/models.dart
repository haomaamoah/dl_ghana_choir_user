import 'package:cloud_firestore/cloud_firestore.dart';

class Members {
  late String pFullName,eFullName,pGender,eGender,pPhone,ePhone,eRelation,password,location,section,role,division,region;
  late Timestamp dob,timestamp;

  Members([pFullName,eFullName,pGender,eGender,pPhone,ePhone,eRelation,password,dob,location,role,section,division,region,timestamp]);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'pFullName': pFullName,'eFullName': eFullName, 'pGender': pGender,'eGender': eGender,
      'pPhone': pPhone,'ePhone': ePhone,'dob': dob,'eRelation': eRelation, 'division': division, 'role': role,
      'password': password,'section': section,'location': location,'region': region,'timestamp': timestamp,
    }; return map;
  }

  Members.fromMap(var map){
    pFullName = map['pFullName'];eFullName = map['eFullName']; pGender = map['pGender'];eGender = map['eGender'];
    pPhone = map['pPhone'];ePhone = map['ePhone'];dob = map['dob'];eRelation = map['eRelation'];division = map['division'];role = map['role'];
    password = map['pwd'];section = map['section'];location = map['location'];region = map['region'];timestamp = map['timestamp'];
  }
}

class Registers {
  late List<dynamic> register;
  late String date,time,purpose,location,region,division;
  late Timestamp timestamp;

  Registers(this.register,this.date,this.time,this.purpose,this.location,this.region,this.division,this.timestamp);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'register': register,'date': date, 'time': time, 'purpose':purpose,
      'location': location, 'region': region, 'division': division, 'timestamp': timestamp
    }; return map;
  }

  Registers.fromMap(Map<String, dynamic> map){
    register = map['register']; date = map['date']; time = map['time']; purpose = map['purpose'];
    location = map['location']; region = map['region']; division = map['division']; timestamp = map['timestamp'];
  }
}

class News {
  late String heading,body,footer,image,section,division,region;
  late Timestamp timestamp;

  News(this.heading,this.body,this.footer,this.image,this.section,this.division,this.region,this.timestamp);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'heading': heading,'footer': footer, 'image': image, 'section': section,
      'body': body, 'region': region, 'division': division, 'timestamp': timestamp
    }; return map;
  }

  News.fromMap(Map<String, dynamic> map){
    heading = map['heading']; footer = map['footer']; image = map['image']; section = map['section'];
    body = map['body']; region = map['region']; division = map['division']; timestamp = map['timestamp'];
  }
}

class Hymns {
  late String title;
  late List<dynamic> verses;
  late Timestamp timestamp;

  Hymns(this.title,this.verses,this.timestamp);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'title': title,'verses': verses, 'timestamp': timestamp
    }; return map;
  }

  Hymns.fromMap(Map<String, dynamic> map){
    title = map['title'];verses = map['verses']; timestamp = map['timestamp'];
  }
}

class Admin {
  String? pwd;

  Admin(this.pwd);

  Map<String,dynamic> toMap(){
    var map = <String, dynamic>{
      'pwd': pwd
    }; return map;
  }

  Admin.fromMap(Map<String, dynamic> map){
    pwd = map['pwd'];
  }
}

class DataUtils {
  static const String
  mainLogo = 'assets/img/comLogo.jpeg',
      mainLogoRound = 'assets/img/comLogo_round.png';
  static const List<String>
  roles = ["CHOIR","ORCHESTRA","C & O"],
      genders = ["MALE","FEMALE"],
      sections = ["CHILD","YOUTH","ADULT","LEADER-CH","LEADER-YTH","LEADER-ALL",],
      regions = ["ACCRA","BIBIANI","BOLGA","CAPE COAST","GOASO","HO","HOHOE","KOFORIDUA", "KONONGO","KUMASI NORTH",
        "KUMASI SOUTH","MADINA","MAMPONG","NKAWIE","OBUASI","SUNYANI","TAKORADI","TAMALE","TARKWA","TECHIMAN","TEMA","WA"];
}
