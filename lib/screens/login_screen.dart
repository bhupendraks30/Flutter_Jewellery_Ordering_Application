import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewellery_ordering_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Welcome To The Jewellery Ordering App",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 30.sp),),
            SizedBox(height: 100.h,),
            SignInButton(buttonSize: ButtonSize.large,buttonType: ButtonType.google,onPressed: (){
              Provider.of<UserAuthProvider>(context,listen: false).signInWithGoogle();
            })
          ],
        ),
      )
    );
  }
}
