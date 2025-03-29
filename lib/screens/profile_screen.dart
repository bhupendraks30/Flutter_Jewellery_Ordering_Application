import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_ordering_app/providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ImagePicker _picker = ImagePicker();

  User? user;

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    File file = File(pickedFile.path);
    String fileName = "profile_pictures/${user!.uid}.jpg";

    try {
      UploadTask uploadTask =
      FirebaseStorage.instance.ref(fileName).putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await user!.updatePhotoURL(downloadUrl);
      Provider.of<UserAuthProvider>(context,listen: false).updateUserProfile(downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final User? _user =
        Provider.of<UserAuthProvider>(context, listen: false).getUser();
    return Scaffold(
      body: Center(
        child: _user == null
            ? Text("User is not Signed In.")
            : Container(
                width: 1.sw,
                height: 400.h,
                margin: EdgeInsets.symmetric(horizontal: 8.r),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                        children: [
                      ClipRRect(
                        child: Image.network(
                          _user.photoURL!,
                          height: 150.h,
                          width: 150.h,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(100.r),
                      ),

                      // Firebase Storage requires a billing plan but I have not purchased this plan so i just create the logic but it is not functionaly without upgraded plan
                      // Padding(
                      //   padding: EdgeInsets.only(top: 12.r),
                      //   child: IconButton(onPressed: ()async{
                      //     await _pickAndUploadImage(context);
                      //   }, icon: const Icon(Icons.edit,color: Colors.white,),style: IconButton.styleFrom(backgroundColor: Colors.blue),),
                      // )
                    ]
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(_user.displayName!),
                    SizedBox(
                      height: 30.h,
                    ),
                    ElevatedButton(
                      onPressed:
                          Provider.of<UserAuthProvider>(context, listen: false)
                              .signOut,
                      child: Text(
                        "Sign Out",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          fixedSize: Size(150.w, 20.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          )),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
