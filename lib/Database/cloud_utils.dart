import 'package:characters/src/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

final cloud = FirebaseFirestore.instance;
final members = cloud.collection('members');
final registers = cloud.collection('registers');
final news = cloud.collection('news');
final hymns = cloud.collection('hymns');
final admins = cloud.collection('admins');

class RegisterDB{
  static Stream<QuerySnapshot> getAllRegister(){
    return registers
        .orderBy('timestamp',descending: true)
        .snapshots();
  }

  static Future<void> addRegister(Registers r) async {
    return registers.doc("${r.timestamp.microsecondsSinceEpoch}").set(r.toMap());
  }

  static Future<void> updateRegister(Registers r) async {
    return registers.doc("${r.timestamp.microsecondsSinceEpoch}").update({
      'register': r.register,
    });
  }

  static Future<void> deleteRegister(Registers r) async {
    return registers.doc("${r.timestamp.microsecondsSinceEpoch}").delete();
  }

  static Stream<QuerySnapshot> searchDate(String date){
    return registers.where("date",isEqualTo:date).snapshots();
  }

  static Stream<QuerySnapshot> searchPurpose(String purpose){
    String temp1 = purpose.substring(0,purpose.length-1);
    String temp2 = purpose.characters.last;
    String _purpose = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return registers
        .where("purpose",isGreaterThanOrEqualTo:purpose)
        .where("purpose",isLessThan:_purpose)
        .snapshots();
  }

  static Stream<QuerySnapshot> searchLocation(String location){
    return registers
        .where("location",isEqualTo: location)
        .snapshots();
  }
}


class MembersDB{
  static Stream<QuerySnapshot> getAllMembers([String? memberID]){
    return members
        .orderBy('pFullName')
        .snapshots();
  }


  static Future<void> addMember(Members m) async {
    return members.doc(m.pPhone).set(m.toMap());
  }

  static Future<void> updateMember(Members m) async {
    return members.doc(m.pPhone).update(m.toMap());
  }

  static Future<void> updatePassword(Members m) async {
    return members.doc(m.pPhone).update({'password':m.password});
  }

  static Future<void> deleteMember(Members m) async {
    return members.doc(m.pPhone).delete();
  }

  static Future<QuerySnapshot> validMember(String memberID){
    return members.where("pPhone",isEqualTo: memberID).get();
  }

  static Stream<QuerySnapshot> searchName(String name){
    String temp1 = name.substring(0,name.length-1);
    String temp2 = name.characters.last;
    String _name = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return members
        .where("pFullName",isGreaterThanOrEqualTo:name)
        .where("pFullName",isLessThan:_name)
        .snapshots();
  }

  static Stream<QuerySnapshot> searchPhone(String phone){
    String temp1 = phone.substring(0,phone.length-1);
    String temp2 = phone.characters.last;
    String _phone = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return members
        .where("pPhone",isGreaterThanOrEqualTo:phone)
        .where("pPhone",isLessThan:_phone)
        .snapshots();
  }

  static Stream<QuerySnapshot> searchGender(String gender){
    return members
        .where("pGender",isEqualTo:gender)
        .orderBy('pFullName')
        .snapshots();
  }

  static Stream<QuerySnapshot> searchLocation(String location){
    return members
        .where("location",isEqualTo: location)
        .orderBy('pFullName')
        .snapshots();
  }

  static Stream<QuerySnapshot> searchRole(String role){
    String temp1 = role.substring(0,role.length-1);
    String temp2 = role.characters.last;
    String _role = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return members
        .where("role",isGreaterThanOrEqualTo:role)
        .where("role",isLessThan:_role)
        .snapshots();
  }
}


class NewsDB{
  static Stream<QuerySnapshot> getAllNews(){
    return news.orderBy('timestamp',descending: true).snapshots();
  }

  static Future<void> addNews(News n) async {
    return news.doc("${n.timestamp.microsecondsSinceEpoch}").set(n.toMap());
  }

  static Future<void> updateNews(News n) async {
    return news.doc("${n.timestamp.microsecondsSinceEpoch}").update(n.toMap());
  }

  static Future<void> deleteNews(News n) async {
    return news.doc("${n.timestamp.microsecondsSinceEpoch}").delete();
  }

  static Stream<QuerySnapshot> searchHeading(String heading){
    String temp1 = heading.substring(0,heading.length-1);
    String temp2 = heading.characters.last;
    String _heading = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return news
        .where("heading",isGreaterThanOrEqualTo:heading)
        .where("heading",isLessThan:_heading)
        .snapshots();
  }

  static Stream<QuerySnapshot> searchLocation(String location){
    return news
        .where("location",isEqualTo: location)
        .orderBy('timestamp',descending: true)
        .snapshots();
  }
}

class HymnsDB{
  static Stream<QuerySnapshot> getAllHymns(){
    return hymns.orderBy('timestamp',descending: true).snapshots();
  }

  static Future<void> addHymns(Hymns h) async {
    return hymns.doc("${h.timestamp.microsecondsSinceEpoch}").set(h.toMap());
  }

  static Future<void> updateHymns(Hymns h) async {
    return hymns.doc("${h.timestamp.microsecondsSinceEpoch}").update(h.toMap());
  }

  static Future<void> deleteHymns(Hymns h) async {
    return hymns.doc("${h.timestamp.microsecondsSinceEpoch}").delete();
  }

  static Stream<QuerySnapshot> searchTitle(String title){
    String temp1 = title.substring(0,title.length-1);
    String temp2 = title.characters.last;
    String _title = temp1 + String.fromCharCode(temp2.codeUnitAt(0)+1);
    return news
        .where("title",isGreaterThanOrEqualTo:title)
        .where("title",isLessThan:_title)
        .snapshots();
  }

}

class AdminDB{
  static Future<DocumentSnapshot>getAdminInfo([String? adminID]){
    return (adminID==null) ?
    admins.doc('evans').get():
    admins.doc(adminID).get();
  }

  static Future<void> updatePassword(Admin a) async {
    DocumentReference admin = admins.doc('evans');
    return admin.update({'pwd':a.pwd});
  }

}