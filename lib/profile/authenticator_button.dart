import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticatorButton extends StatelessWidget {
  const AuthenticatorButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () async {
            await showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                String username = '';
                String password = '';
                return SimpleDialog(
                  title: Column(
                    children: <Widget>[
                      Text(
                        'Login to continue',
                        textAlign: TextAlign.center,
                      ),
                      TextField(
                        decoration: InputDecoration(hintText: 'e-mail'),
                        onChanged: (value) {
                          username = value;
                        },
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: 'password'),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                    ],
                  ),
                  children: <Widget>[
                    FlatButton(
                      child: Text('Login'),
                      onPressed: () async {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        try {
                          final result = await _auth.signInWithEmailAndPassword(
                            email: username,
                            password: password,
                          );
                          print(result);
                          Fluttertoast.showToast(
                            msg: "Logged in",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Theme.of(context).backgroundColor,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: "Error during log in",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          print(e);
                        }
                      },
                    ),
                    // FlatButton(
                    //   child: Text('Register'),
                    //   onPressed: () async {
                    //     final FirebaseAuth _auth = FirebaseAuth.instance;
                    //     try {
                    //       final result =
                    //           await _auth.createUserWithEmailAndPassword(
                    //         email: username,
                    //         password: password,
                    //       );
                    //       print(result);
                    //     } catch (e) {
                    //       print(e);
                    //       Fluttertoast.showToast(
                    //         msg: "Error during registration",
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.CENTER,
                    //         timeInSecForIos: 1,
                    //         backgroundColor:
                    //             Theme.of(context).backgroundColor,
                    //         fontSize: 16.0,
                    //       );
                    //       Navigator.pop(context);
                    //     }
                    //   },
                    // ),
                    FlatButton(
                      child: Text('Logout'),
                      onPressed: () async {
                        final FirebaseAuth _auth = FirebaseAuth.instance;
                        Fluttertoast.showToast(
                          msg: "Logged out",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIos: 1,
                          backgroundColor: Theme.of(context).backgroundColor,
                          fontSize: 16.0,
                        );
                        try {
                          await _auth.signOut();
                        } catch (e) {
                          print(e);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
