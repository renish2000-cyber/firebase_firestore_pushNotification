import 'package:crudoperation/dashboard.dart';
import 'package:crudoperation/google_auth/register.dart';
import 'package:crudoperation/notification_service/notificationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'google_auth/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController uName = TextEditingController();
  TextEditingController pName = TextEditingController();
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger= ScaffoldMessenger.of(context);
    /*
    * Login Method
    * */
    Future<void> login() async {
      String email = uName.text.trim();
      String psw = pName.text.trim();

      if (email.isEmpty || psw.isEmpty) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text("Please fill all the details!"),
          duration: Duration(seconds: 1),
        ));
      } else {
        try {
          // Save user credentials
          UserCredential userCredential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: psw);

          if (userCredential.user != null) {
            scaffoldMessenger.showSnackBar(const SnackBar(
                content: Text("You're logged in successfully!")));

            // Reset controls
            uName.clear();
            pName.clear();

            // remove focus
            primaryFocus?.unfocus();

            Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard_Screen(userCredential),));
          }
        } on FirebaseAuthException catch (e) {
          scaffoldMessenger
              .showSnackBar(SnackBar(content: Text(e.code.toString())));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: uName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter login email"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: pName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter login password"),
              ),
            ),
            ElevatedButton(
                onPressed: ()async {
                  await login();
                },
                child: Text("Login")),
            OutlinedButton.icon(
              onPressed: () async{
                await loginUsingGoogle();
              },
              icon: const Icon(Icons.g_mobiledata_outlined),
              label: const Text("Login using Google"),
            ),
            TextButton(child: const Text("Create Account"),onPressed: ()async{Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUser(),));},),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () async{
                await subscribeNotification();
              },
              icon: const Icon(Icons.g_mobiledata_outlined),
              label: const Text("subscribe to get notification"),
            ),
          ],
        ),
      ),
    );

  }

  loginUsingGoogle() async{
    dynamic userData=await AuthService().SignInWithGoogle();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard_Screen(userData),));
  }



  /*
  * Topic for send Notification who subscribe for specific topic
  * https://www.youtube.com/watch?v=AV68O0T2PJs
  * */
  subscribeNotification() async{
    await FirebaseMessaging.instance.subscribeToTopic("demopurpose");
  }


}
