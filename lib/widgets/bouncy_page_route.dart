import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BouncyPageRoute extends PageRouteBuilder{
  Widget? widget;
  BouncyPageRoute({this.widget}):super(
    transitionDuration: Duration(seconds: 2),
    transitionsBuilder: (BuildContext context,
    Animation<double> animation,
    Animation<double> secAnimation,
    Widget child){
      animation = CurvedAnimation(parent: animation,curve: Curves.elasticInOut);
      return ScaleTransition(
        alignment: Alignment.center,
        scale: animation,
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secAnimation){return widget ?? SizedBox();}
  );
}

class FadePageRoute extends PageRouteBuilder{
  Widget? widget;
  FadePageRoute({this.widget}):super(
      transitionDuration: Duration(milliseconds: 400),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation,
          Widget? child){
        return ScaleTransition(
          alignment: Alignment.center,
          scale: animation,
          child: child,
        );
      },
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secAnimation){return widget ?? SizedBox();}
  );
}
