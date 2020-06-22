import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loginui/variables/vars.dart';
class controlUser extends StatefulWidget {
  @override
  _controlUserState createState() => _controlUserState();
}

class _controlUserState extends State<controlUser> {
  DatabaseReference users = FirebaseDatabase.instance.reference().child("Users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
        backgroundColor: background_2,
      ),
      body: StreamBuilder(
        builder: (context, snapshot){
          if(snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

            return ListView.builder(
                itemBuilder: (context,int index){
                  return ListTile(
                    title:Text(map.values.toList()[index]['email']),
                    subtitle: Text(map.values.toList()[index]['identity']),
                    leading: Icon(Icons.account_circle),
                  );
                },
                itemCount: map.values.toList().length
            );
          }
          return Center(child: Text("No users yet"));
        },
        stream: users.onValue,
      ),
    );
  }
}
