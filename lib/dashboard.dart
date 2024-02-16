import 'package:crudoperation/database/databaseService.dart';
import 'package:crudoperation/model/Todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class Dashboard_Screen extends StatefulWidget {
  UserCredential userData;

  Dashboard_Screen(this.userData, {super.key});

  @override
  State<Dashboard_Screen> createState() => _Dashboard_ScreenState();
}

class _Dashboard_ScreenState extends State<Dashboard_Screen> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        actions: [
          IconButton(
              onPressed: () async {
                await _signOut();
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () async {
                await showUserInfoDialog();
              },
              icon: const Icon(Icons.account_circle_outlined)),
        ],
      ),
      body: StreamBuilder(
        stream: databaseService.getTodo(),
        builder: (context, snapshot) {
          List<dynamic> todoList = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Todo todo = todoList[index].data();
              String docId=snapshot.data!.docs[index].id;
              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(todo.name),
                  dense: true,
                  tileColor: Colors.grey,
                  trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () async{
                              await _showDialog(context,false,docId: docId);
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.green,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () async{
                             await databaseService.deleteNote(docId);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showDialog(context,true);
          },
          child: Icon(Icons.add)),
    );
  }

  // Function to show the dialog
  Future<void> _showDialog(BuildContext context,bool isAdd, {String docId=""}) async {
    String textFieldValue = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Task'),
          content: TextField(
            onChanged: (value) {
              textFieldValue = value;
            },
            decoration: InputDecoration(
              hintText: 'Type something...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Todo todo = Todo(textFieldValue, false);
                isAdd ? databaseService.addTodo(todo) : databaseService.updateTodo(docId, todo);
                print('Entered Text: $textFieldValue');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    print("User signed out successfully");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
            (route) => false);
  }

  /*
  * Dialog box to display user info
  * */
  showUserInfoDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return  Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 10),
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: Image.network(
                      widget.userData.user!.photoURL.toString(),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.userData.user!.displayName.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.userData.user!.email.toString(),
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            )
        );
      },
    );
  }
}
