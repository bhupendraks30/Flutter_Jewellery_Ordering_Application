import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jewellery_ordering_app/firebase_options.dart';
import 'package:jewellery_ordering_app/providers/auth_provider.dart';
import 'package:jewellery_ordering_app/providers/cart_provider.dart';
import 'package:jewellery_ordering_app/providers/product_provider.dart';
import 'package:jewellery_ordering_app/providers/sold_data_provider.dart';
import 'package:jewellery_ordering_app/screens/bottom_nav_screen.dart';
import 'package:jewellery_ordering_app/screens/home_screen.dart';
import 'package:jewellery_ordering_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // initializing the firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then((value) { },);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAuthProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider(),),
        ChangeNotifierProvider(create: (context) => ProductProvider(),),
        ChangeNotifierProvider(create:  (context) => SoldDataProvider(),)
      ],
      child: ScreenUtilInit(
        designSize: Size(screenWidth,screenHight),
        minTextAdapt: true,
        ensureScreenSize: true,
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Jewellery Ordering App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            useMaterial3: true,
          ),
          home: const UserSessionHandler(),
        ),
      ),
    );
  }
}

class UserSessionHandler extends StatelessWidget {
  const UserSessionHandler({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<UserAuthProvider>(
      builder: (context, authProvider, _) {
        return authProvider.getUser() != null ? const BottomNavScreen() : LoginScreen();
      },
    );
  }
}








