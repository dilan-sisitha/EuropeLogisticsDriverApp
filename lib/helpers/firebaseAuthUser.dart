import 'dart:convert';
import 'package:euex/helpers/validator.dart';
import 'package:euex/services/driverService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
class FirebaseAuthUser{

  checkCurrentUserState(){

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async{
      if (user == null) {
        await signInWithCredentials();
      }
    });

  }
  createUser()async{
    try {
      Map<String,String> credentials = firebaseCredentials;
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: credentials["email"]!,
        password:credentials["password"]!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signInWithCredentials()async{
    try {
      Map<String,String> credentials = firebaseCredentials;
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: credentials["email"]!,
          password:credentials["password"]!,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        await createUser();
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Map<String,String> get firebaseCredentials{
    String userName = DriverService().getDriverDetails("user_name");
    bool isEmail  = Validator().isEmail(userName);
    String email = '';
    if(isEmail){
      email = userName;
    }else{
      email = "${userName.replaceAll(" ", '')}@email.com";
    }
    var bytes = utf8.encode(email);         // data being hashed
    var digest = sha256.convert(bytes);
    return{
      "email":email,
      "password":digest.toString()
    };
  }

  signOut()async{
    await FirebaseAuth.instance.signOut();
  }
}