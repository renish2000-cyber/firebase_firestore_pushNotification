import 'package:crudoperation/database/databaseService.dart';
import 'package:crudoperation/model/Todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'login.dart';

class Dashboard_Screen extends StatefulWidget {
  dynamic userData;

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
        ],
      ),
      body: StreamBuilder(
        stream: databaseService.getTodo(),
        builder: (context, snapshot) {
          List<dynamic> todoList = snapshot.data?.docs ?? [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Todo todo = todoList[index].data();
              return Text(todo.name);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _showDialog(context);
          },
          child: Icon(Icons.add)),
    );
  }

  // Function to show the dialog
  Future<void> _showDialog(BuildContext context) async {
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
                databaseService.addTodo(todo);
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
}
