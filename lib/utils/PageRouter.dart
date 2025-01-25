import 'package:flutter/material.dart';
import 'package:xie_hackathon/pages/LoginPage.dart';
import 'package:xie_hackathon/pages/SignUpPage.dart';
import '../pages/ChatBot.dart';
import '../pages/DiagnosticFormPage.dart';
import '../pages/ImagePickerPage.dart';
import '../pages/IntroductionAnimationScreen.dart';
import '../pages/LivestockFeedingmdl.dart';
import '../pages/MyHomePage.dart';

class PageRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => IntroductionAnimationScreen(),
            transitionDuration: Duration(seconds: 2));

      case '/MyHomePage':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => MyHomePage(),
            transitionDuration: Duration(seconds: 2));

      case '/SignUp':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => SignUp(),
            transitionDuration: Duration(seconds: 2));

      case '/LoginPage':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => LoginPage(),
            transitionDuration: Duration(seconds: 2));

      case '/ChatBot':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ChatBot(),
            transitionDuration: Duration(seconds: 2));
      
       case '/LivestockFeeding':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => LivestockFeeding(),
            transitionDuration: Duration(seconds: 2));

       case '/DiagnosticFormPage':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => DiagnosticFormPage(),
            transitionDuration: Duration(seconds: 2));

      case '/ImagePickerPage':
        return PageRouteBuilder(
            pageBuilder: (_, __, ___) => ImagePickerPage(),
            transitionDuration: Duration(seconds: 2));


      default:
        return PageRouteBuilder(pageBuilder: (_, __, ___) => MyHomePage());
    }
  }
}
