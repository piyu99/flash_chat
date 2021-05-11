import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {

  static const String id='registrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}


FirebaseAuth _auth=FirebaseAuth.instance;
TextEditingController codeController=TextEditingController();
String _verificationCode;

class _RegistrationScreenState extends State<RegistrationScreen> {

  String email;
  String password;
  String phone;

  TextEditingController _controller=TextEditingController();



  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();
    verifywithphone( context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 150.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                phone=value;
              },
              decoration: InputDecoration(
                fillColor: Colors.yellowAccent,
                hintText: 'Enter your phone',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password=value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your password',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async{
                    String phoneno=_controller.text.trim();
//                    try {
//                      var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//                      Navigator.pushNamed(context, ChatScreen.id);
//                    }
//                    catch(e) {
//                      print(e);
//                    }
                  //verifywithphone(phoneno,context);
                    try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                          verificationId: _verificationCode, smsCode: codeController.text.trim()))
                          .then((value) async {
                        if (value.user != null) {

                        }
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  verifywithphone(BuildContext context){

    _auth.verifyPhoneNumber(
        phoneNumber: '+917678659106',
//      verificationCompleted: (AuthCredential credential)async{
//        Navigator.pop(context);
//       UserCredential result= await _auth.signInWithCredential(credential);
//
//       print(result.user.email);
//       print(result.user.uid);
//      },
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              print(value.user.uid);
            }
          });
        },
//      verificationFailed: (FirebaseAuthException exception){
//        print(exception);
//      },
//      codeSent: (String verificationId,[int forceSendingcode]){
//        showDialog(context: context,
//            builder: (context){
//          return AlertDialog(
//            title: Text('ENTER THE CODE'),
//            content: Column(
//              children: [
//                TextField(
//                  controller: codeController,
//                )
//              ],
//            ),
//            actions: [
//              TextButton(onPressed: () async {
//                String code=codeController.text.trim();
//                PhoneAuthCredential cred = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
//                UserCredential result= await _auth.signInWithCredential(cred);
//                print(result.user.uid);
//              },
//                  child: Text('Submit'))
//            ],
//          );
//        }
//        );
//      },
//      codeAutoRetrievalTimeout: (verificationId)async{
//      },
//    timeout: Duration(seconds: 120),
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));


  }
}


