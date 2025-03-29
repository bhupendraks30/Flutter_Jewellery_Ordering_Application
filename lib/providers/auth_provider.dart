import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:jewellery_ordering_app/services/auth_services.dart';

class UserAuthProvider with ChangeNotifier{
  final AuthService _authService = AuthService();
  User? _user=null;


  UserAuthProvider(){
    FirebaseAuth.instance.authStateChanges().listen((event) {
      _user = event;
      notifyListeners();
    },);
  }

  User? getUser()=>_user;

  Future<void> signInWithGoogle()async{
    _user =await _authService.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signOut()async{
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // used to update the user's profile
  Future<void> updateUserProfile(String? photoUrl)async{
    try {
      if (_user != null) {
        await _user?.updatePhotoURL(photoUrl);
        await _user?.reload(); // Refresh user data
      }else{
        print("user is null");
      }
    } catch (e) {
      print("Profile Update Error: $e");
    }
  }
}