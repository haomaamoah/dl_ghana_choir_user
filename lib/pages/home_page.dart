import 'package:dl_gh_choir_user/Database/models.dart';
import 'package:dl_gh_choir_user/pages/hymn_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../forms/change_password.dart';
import '../forms/login_page.dart';
import '../widgets/bouncy_page_route.dart';
import '../widgets/dialogs.dart';
import '../widgets/accessories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'register_page.dart';
import 'news_page.dart';

class HomePage extends StatefulWidget {
  Members? member;
  HomePage(Members member){this.member=member;}

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{


  AnimationController? rotationController;
  Members? member;

  void logOut()=>LogoutDialog(context, LoginForm());

  Future<void> callAdmin() async {
    await launch('tel:0548143869');
  }

  @override
  void initState() {
    super.initState();
    member = widget.member!;
    rotationController = AnimationController(vsync: this,duration: Duration(seconds: 4));
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
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: Container(
              width: 200,
              child: Drawer(
                child: ListView(
                    children:[
                      DrawerHeader(
                        child: Column(
                          children: [
                            AnimatedBuilder(
                                animation: rotationController!,
                                builder: (BuildContext context,widget){
                                  return Transform.rotate(angle: rotationController!.value*6.3,child: widget,);
                                },
                                child:Image.asset('assets/img/comLogo_round.png',
                                  height: 70,width:70,
                                  fit: BoxFit.contain,)),
                            Container(
                                width: 150,
                                child: SelectableText(member!.pFullName,textAlign: TextAlign.center,style: TextStyle(fontSize:18,color:Colors.black87))
                            ),
                            Divider(color: Colors.green[700],thickness:1),
                            SelectableText(member!.pPhone,textAlign: TextAlign.center,style: TextStyle(fontSize:16,color:Colors.black87,fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('View Profile',style: TextStyle(fontSize:17,color:Colors.black54)),
                        leading: FaIcon(FontAwesomeIcons.userAlt,size: 20,color:Colors.black),
                        onTap: ()=>memberInfoDialog(context, member!),
                      ),
                      Divider(thickness: 1),
                      ListTile(
                          title: Text('Call Administrator',style: TextStyle(fontSize:17,color:Colors.black54)),
                          leading: FaIcon(FontAwesomeIcons.phoneSquareAlt,size: 20,color:Colors.blue),
                          onTap: callAdmin
                      ),
                      Divider(thickness: 0.8),
                      ListTile(
                        title: Text('Change Password',style: TextStyle(fontSize:17,color:Colors.black54)),
                        leading: FaIcon(FontAwesomeIcons.lock,size: 20,color:Colors.green),
                        onTap: ()=>Navigator.push(context, FadePageRoute(widget:PasswordForm(member))),
                      ),
                      Divider(thickness: 0.8),
                      ListTile(
                        title: Text('Log Out',style: TextStyle(fontSize:17,color:Colors.black54)),
                        leading: FaIcon(Icons.logout,size: 20,color:Colors.red),
                        onTap: logOut,
                      ),
                      Divider(thickness: 0.8),

                    ]
                ),
              ),
            ),
            backgroundColor: Colors.white,
            appBar: homeAppBar(),
            body: TabBarView(children: [
              NewsPage(),
              HymnPage(),
              RegisterPage(),
            ]),
          ),
        ),
        onWillPop: ()=>SystemNavigator.pop() as Future<bool>);
  }
}
