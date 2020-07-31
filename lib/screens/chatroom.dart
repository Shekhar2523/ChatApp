import 'package:chat_app/helper/Constants.dart';
import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/heplerfunctions.dart';
import 'package:chat_app/screens/chatscreen.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/screens/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context,snapshot){
        return snapshot.hasData ?ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              return ChatRoomTile(userName :
                snapshot.data.documents[index].data["chatRoomId"].toString().replaceAll( "_" , "").replaceAll(Constants.myName, "").toUpperCase(),chatRoomId: snapshot.data.documents[index].data["chatRoomId"] ,
              );
            }):spinKit;
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo()async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/IconBrand1.PNG",
        height: 45.0,),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> Authenticate()));

            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context,MaterialPageRoute(
            builder: (context)=>SearchScreen()
          ));
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({this.userName,this.chatRoomId});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomId: chatRoomId)));
      },
      child: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40)
              ),
              child: Text("${userName.substring(0,1).toString()}",
              style: mediumTextStyle(Colors.black,
              ),
              ),
            ),
            SizedBox(width: 8,),
            Text(userName,style: mediumTextStyle(Colors.black),)
          ],
        ),
      ),
    );
  }
}
