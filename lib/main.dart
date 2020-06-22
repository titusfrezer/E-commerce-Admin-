import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:loginui/UI/Admin/AddCategory.dart';
import 'package:loginui/variables/vars.dart';
//import 'package:sms/sms.dart';

import 'auth_service.dart';

import 'package:firebase_database/firebase_database.dart';

DatabaseReference catagoryRef;
var catkeys;
var catValue;


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
//  SmsQuery query = SmsQuery();
//  List<SmsMessage> message=await query.getAllSms;
//  print(message);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp( MaterialApp(
//navigatorKey: Get.key,
//    key: Get.key,
        routes: {
          //'/': (BuildContext context) => AuthPage(),
          '/AddCategory': (BuildContext context)=>AddCategory()

        }
        ,theme:ThemeData(

        primaryColor: background_2
    ),
        home:  MyApp()));
  });


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Online shop",

        home: HomeController(),
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? AddCategory() : LoginScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
class Provider extends InheritedWidget {
  final AuthService auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}


class LoginScreen extends StatelessWidget {


  TextEditingController email= TextEditingController();
  TextEditingController passowrd=TextEditingController();
  TextEditingController confirmPassword=TextEditingController();
  Duration get loginTime => Duration(milliseconds: 2250);

  Future<String> _authUser (LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_)async {

      try{
         await FirebaseAuth.instance.signInWithEmailAndPassword(email: data.name, password: data.password);
      }catch(Exception){
        print(Exception);
        if(Exception.toString()=="PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)"){
          return 'Connection Error Please try again';

        }

        return 'Email or Password not exists';
      }


      return null;
    });
  }
Future<String> _signupUser(LoginData data){

//  print('Name: ${data.name}, Password: ${data.password}');
  return Future.delayed(loginTime).then((_)async {
//    if (users.containsKey(data.name)) {
//      return 'Username exists';
//    }
//    if (users[data.name] != data.password) {
//      return 'Password does not match';
//    }
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.name, password: data.password);

    }catch(e){
      print(e);
      if(e.toString()=="PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)"){
        return 'Connection Error Please try again';

      }

      return 'Email already exists';
    }
    return null;
  });
}
  Future<String> _recoverPassword(String name) {

    return Future.delayed(loginTime).then((_) async{
//      if (!users.containsKey(name)) {
//        return 'Username not exists';
//      }
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
       print('user');

      }catch(e){
        if(e.toString()=="PlatformException(ERROR_NETWORK_REQUEST_FAILED, A network error (such as timeout, interrupted connection or unreachable host) has occurred., null)"){
          return 'Connection Error Please try again';

        }
        return 'Email not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {

    return FlutterLogin(
      theme: LoginTheme(
        buttonTheme: LoginButtonTheme(
            backgroundColor: background
        ),
        primaryColor: background_2,
        //pageColorDark: background_2
      ),
      title: 'E-commerce',
      logo: 'assets/images/ecorp-lightblue.png',
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {


Navigator.of(context).push(MaterialPageRoute(builder: (context)=>

AddCategory()));


      },
      onRecoverPassword: _recoverPassword,
    );
  }
}


