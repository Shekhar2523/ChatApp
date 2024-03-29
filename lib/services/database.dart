

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByUserName(String userName)async{
    return await Firestore.instance.collection("users").where("name",isEqualTo: userName).getDocuments();
  }

  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection("users").where("email",isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }
  
  createChatRoom(String chatRoomId,Map chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
          print(e.toString());
        });
  }

  addChatMessages(String chatRoomId,messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getChatMessages(String chatRoomId)async{
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).collection("chats")
        .orderBy("time",descending: false)
        .snapshots();
  }
  
  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users",arrayContains: userName)
        .snapshots();
  }
  
}