import 'package:chat_app/helper/heplerfunctions.dart';
import 'package:chat_app/screens/chatroom.dart';
import 'package:chat_app/screens/forgetpassword.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn(this.toggleView);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  QuerySnapshot snapshotUserInfo;
  
  signIn(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      setState(() {
        isLoading =true;
      });
      
      databaseMethods.getUserByUserEmail(emailTextEditingController.text)
    .then((val){snapshotUserInfo = val;
    HelperFunctions.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
      });

      authMethod
          .signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
          .then((value) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
      } );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: isLoading?spinKit: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8.0,),
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?null:"Enter a valid Email ";
                      },
                      controller: emailTextEditingController,
                      decoration: textFileInputDecoration("Email"),
                      style: simpleTextStyle(),
                    ),
                    SizedBox(height: 8.0,),
                    TextFormField(
                      validator: (val){
                        return val.length>6?null:"Provide a strong password";
                      },
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: textFileInputDecoration("Password"),
                      style: simpleTextStyle(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0,),
              Container(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 8.0),
                  child: GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));}, child: Text("Forget Password",style: simpleTextStyle(),)),
                ),
              ),
              SizedBox(height: 8.0,),
              GestureDetector(
                onTap: (){
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.orangeAccent,
                          Colors.deepOrange,
                          Colors.deepOrangeAccent,
                          Colors.orange,
                        ]
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Log In",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),),
                ),
              ),
              SizedBox(height: 8.0,),
              SizedBox(height: 8.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have a account? ",style: TextStyle(color :Colors.blueAccent,fontSize: 16.0),),
                  GestureDetector(onTap: (){
                    widget.toggleView();},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0,),
                      child: Text("Register Now",
                        style:TextStyle(
                          color :Colors.blueAccent,
                          fontSize: 16.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.0,),
            ],
          ),
        ),
      ),
    );
  }
}
