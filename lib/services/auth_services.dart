import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // initialize the firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // this is use for google SingIn
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign In with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      // when user cancel the login process then googleUser is null
      if (googleUser == null) return null;

      // getting the user's authentications e.g. Token id(tha JWT token), or access token (this provide the access of email,drive etc.)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
