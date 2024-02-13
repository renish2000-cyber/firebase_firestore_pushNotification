// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  SignInWithGoogle()async{
    final GoogleSignInAccount? gUser= await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth= await gUser!.authentication;
    final credential=GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}