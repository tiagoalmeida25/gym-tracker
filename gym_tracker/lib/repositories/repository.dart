import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_tracker/model/user.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserRepository({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser;
  }

  Future<User?> signInWithEmail(String email, String password) async {
    final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  Future<List<void>> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  void updateProfile(CustomUser user, String username, int age, int weight, int height, String gender,
      String? profilePictureUrl) {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser?.displayName != username) {
      currentUser?.updateDisplayName(username);
    }

    if (profilePictureUrl != null) {
      currentUser?.updatePhotoURL(profilePictureUrl);
    }

    FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).set({
      'gender': gender,
      'weight': weight,
      'height': height,
      'age': age,
    });
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();
}