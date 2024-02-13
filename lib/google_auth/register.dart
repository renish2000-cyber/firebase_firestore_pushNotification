import 'package:crudoperation/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController uName = TextEditingController();
  TextEditingController pName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger= ScaffoldMessenger.of(context);
    Future<void> createAccount() async {
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
              .createUserWithEmailAndPassword(email: email, password: psw);

          if (userCredential.user != null) {
            scaffoldMessenger.showSnackBar(
                const SnackBar(content: Text("User Created Successfully!")));

            // Reset controls
            uName.clear();
            pName.clear();
            // remove focus
            primaryFocus?.unfocus();

            /*
         * popUntil() - To pop till the first screen
         * pushReplacement() - To replace the first screen with Login screen
         * */
            /*navigator.popUntil((route) => route.isFirst);
        navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));*/

            /*
             * pushAndRemoveUntil - it's combination of 2[popUntil + pushReplacement] method's functionality
             * Used for navigating to Login screen & remove all screens from stack [if False]
             * */
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RegisterUser()),
                    (route) => false);
          }
        } on FirebaseAuthException catch (e) {
          scaffoldMessenger
              .showSnackBar(SnackBar(content: Text(e.message.toString())));
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Register User"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: uName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Register email"),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: pName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Register password"),
            ),
          ),
          ElevatedButton(
              onPressed: ()async {
                await createAccount();
              },
              child: Text("Register")),
          TextButton(child: Text("Login"),onPressed: ()async{
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const LoginScreen();
            },));
          },)
        ],
      ),
    );
  }
}
