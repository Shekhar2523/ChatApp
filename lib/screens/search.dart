import 'package:chat_app/helper/Constants.dart';
import 'package:chat_app/screens/chatscreen.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();

  QuerySnapshot searchSnapshot ;

  Future initiateSearch()async{
    setState(() {
      searchSnapshot = null;
    });
    await databaseMethods
        .getUserByUserName(searchTextEditingController.text)
        .then((val){
         setState(() {
           searchSnapshot = val;
         });
        });
  }
  
  createChatRoomAndStartConversation({String userName}){

   if(userName != Constants.myName){
     String chatRoomId = getChatRoomId(userName, Constants.myName);
     List<String> users = [userName,Constants.myName];
     Map<String,dynamic>chatRoomMap = {
       "users":users,
       "chatRoomId":chatRoomId,
     } ;
     databaseMethods.createChatRoom(chatRoomId,chatRoomMap);
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: chatRoomId)));
   }else{
     print("You cannot chat with yourself");
   }
  }

  Widget searchTile({String userName ,String userEmail}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0,horizontal:24.0 ),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(userName,style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),),
              Text(userEmail,style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartConversation(userName:userName);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0)
              ),
              padding: EdgeInsets.symmetric(vertical:16.0 ,horizontal: 16.0),
              child: Text("Message",style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),),
            ),
          )
        ],
      ),
    );
  }


  Widget searchList(){
    return searchSnapshot!= null? ListView.builder(
      itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
        return searchTile(
          userName: searchSnapshot.documents[index].data["name"],
          userEmail: searchSnapshot.documents[index].data["email"],
        );
    }):Container(padding: EdgeInsets.symmetric(vertical: 50.0), child: spinKit);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.cyan,
              padding:EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
              child:Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchTextEditingController,
                      cursorColor: Colors.pinkAccent,
                      style: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                        decoration: InputDecoration(
                          hintText: "Search Usename....",
                          hintStyle: TextStyle(
                            color: Colors.pinkAccent,
                          ),
                          border: InputBorder.none,
                        ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.amber,
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.search),
                    ),

                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}


getChatRoomId(String a ,String b ){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return"$b\_$a";
  }else{
    return "$a\_$b";
  }
}
