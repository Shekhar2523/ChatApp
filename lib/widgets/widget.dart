import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget appBar(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/IconBrand1.PNG",height: 45.0,),
  );
}

InputDecoration textFileInputDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.amberAccent,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.orange),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.deepOrange),
    ),
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
  );
}

TextStyle mediumTextStyle(color){
  return TextStyle(
    color: color,
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
  );
}

final spinKit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.deepOrange : Colors.pinkAccent,
      ),
    );
  },
);

