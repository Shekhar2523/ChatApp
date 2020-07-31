import 'package:chat_app/helper/heplerfunctions.dart';
import 'package:chat_app/screens/chatroom.dart';
import 'package:chat_app/screens/forgetpassword.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethod = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;


  signMeUp(){
    if(formKey.currentState.validate()){
      Map<String ,String> userInfoMap ={
        "name":userNameTextEditingController.text,
        "email":emailTextEditingController.text,
      };
      setState(() {
        isLoading=true;
      });
      authMethod.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text).then((value) => print("${value.userId}"));
      HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEditingController.text);
      databaseMethod.uploadUserInfo(userInfoMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>ChatRoom()
      ));
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
                      controller: userNameTextEditingController,
                      validator: (val){
                        return val.length > 5? null:"Enter username longer than 5 words";
                      },
                      decoration: textFileInputDecoration("Username"),
                      style: simpleTextStyle(),
                    ),
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
                  signMeUp();
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
                  child: Text("Sign Up",style: TextStyle(
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
                  Text("Already have a account? ",style: TextStyle(color :Colors.blueAccent,fontSize: 16.0),),
                  GestureDetector(onTap: (){
                      widget.toggleView();},
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0,),
                      child: Text("Sign In",
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
