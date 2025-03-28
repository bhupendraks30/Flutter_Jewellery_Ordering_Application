import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jewellery_ordering_app/providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> getImageFromGallary(BuildContext context) async {
    final XFile? pickedImageXFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImageXFile != null) {
      File pickedImageFile = File(pickedImageXFile.path);

      //   store this file into local storage
      final directory = await getApplicationDocumentsDirectory();
      // creating the local path
      final localPath = "${directory.path}/profile.jpg";
      //   after creating the path coping the pick image into this path that is stored in temporary storage
      pickedImageFile.copy(localPath);

      Provider.of<UserAuthProvider>(context, listen: false)
          .updateUserProfile(localPath);
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

                      // Padding(
                      //   padding: EdgeInsets.only(top: 12.r),
                      //   child: IconButton(onPressed: ()async{
                      //     await getImageFromGallary(context);
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
