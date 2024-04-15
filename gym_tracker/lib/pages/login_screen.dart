import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_tracker/bloc/auth/authentication_bloc.dart';
import 'package:gym_tracker/model/user.dart';
import 'package:gym_tracker/pages/signup_screen.dart';
import 'package:gym_tracker/pages/signup_with_google.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _signInWithEmail() async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        final User user = userCredential.user!;
        BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
            user: CustomUser(
          id: user.uid,
          username: user.displayName!,
          email: user.email!,
          profilePictureUrl: user.photoURL,
        )));
      }
    } catch (e) {
      // Handle errors
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (mounted) {
        if (userCredential.additionalUserInfo!.isNewUser) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignupWithGoogle(user: userCredential.user!)));
        } else {
          final User user = userCredential.user!;
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
              user: CustomUser(
            id: user.uid,
            username: user.displayName!,
            email: user.email!,
            profilePictureUrl: user.photoURL,
          )));
        }
      }
    } catch (e) {
      // Handle errors
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Welcome to Gym Tracker',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _signInWithEmail,
                    child: const Text('Login with Email'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 8, left: 16),
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                      const Text('or'),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, right: 16),
                          height: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Image.asset('assets/images/google.png', width: 50, height: 50)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? ', style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Sign up now!', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
