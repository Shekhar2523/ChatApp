import 'package:chat_app/services/auth.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  AuthMethod authMethod = new AuthMethod();
  String msg ="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
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
                      ],
                  ),
                ),
                SizedBox(height: 16.0,),
                GestureDetector(
                  onTap: (){
                    authMethod.resetPass(emailTextEditingController.text).then((value) => setState((){
                      msg = "Your password has been sent to your email";
                    }));

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
                    child: Text("Reset Password",style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),),
                  ),
                ),
                SizedBox(height: 16.0,),
                Row(
                  children: <Widget>[
                    Text("$msg",style: TextStyle(
                      color: Colors.red,
                      fontSize: 25.0,
                    ),),
                  ],
                )
              ]
          ),
        ),
      ),
    );
  }
}
