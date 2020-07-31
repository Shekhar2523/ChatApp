import 'package:chat_app/helper/Constants.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  ChatScreen({this.chatRoomId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextEditingController = new TextEditingController();
  Stream chatMessagesStream;

  Widget chatMessageList(){
    return StreamBuilder(
      stream:chatMessagesStream,
      builder: (context,snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
            return MessageTile(message: snapshot.data.documents[index].data["message"],
            isSendByMe: snapshot.data.documents[index].data["sendBy"] == Constants.myName,
            );
            },
        ):spinKit;
    },
    );
  }

  sendMessage(){
    if(messageTextEditingController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message": messageTextEditingController.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addChatMessages(widget.chatRoomId,messageMap);
      messageTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getChatMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessagesStream = val;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.cyan,
                padding:EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
                child:Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextEditingController,
                        cursorColor: Colors.pinkAccent,
                        style: TextStyle(
                          color: Colors.pinkAccent,
                        ),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(
                            color: Colors.pinkAccent,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.blueAccent,
                                Colors.blue,
                              ]
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.send ,color: Colors.black87,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile({this.message,this.isSendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 60 : 0 , right: isSendByMe ? 0:60),
      margin: EdgeInsets.symmetric(vertical: 2,horizontal: 1.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              Colors.lightBlueAccent,
              Colors.blueAccent,
            ] :[
              Colors.orange,
              Colors.orangeAccent,
            ]
          ),
          borderRadius:  isSendByMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(23),
              ):
          BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23),
          )
        ),
        child: Text(message,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.0
          ),
        ),
      ),
    );
  }
}
