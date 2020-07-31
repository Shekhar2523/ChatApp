import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/heplerfunctions.dart';
import 'package:chat_app/screens/chatroom.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn;
  getLoggedInState()async{
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState((){
        isUserLoggedIn = value;
      });
    });
  }
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: isUserLoggedIn !=null ?/**/ isUserLoggedIn ? ChatRoom() : Authenticate() /**/ : Authenticate(),
    );
  }
}