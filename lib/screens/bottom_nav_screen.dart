import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jewellery_ordering_app/providers/cart_provider.dart';
import 'package:jewellery_ordering_app/providers/sold_data_provider.dart';
import 'package:jewellery_ordering_app/screens/cart_page.dart';
import 'package:jewellery_ordering_app/screens/home_screen.dart';
import 'package:jewellery_ordering_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _currentIndex = 0;
  String appBarTitle = "Home Page";
  final List<Widget> _screens = [HomeScreen(), ProfileScreen()];

  void _onBottomNavItemTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Fluttertoast.showToast(msg: '${Provider.of<SoldDataProvider>(context).getSoldData().length}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          Stack(
            alignment: Alignment.topRight,
              children: [
            IconButton(
                onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(),));
                },
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 25.r,
                )),

                Provider.of<CartProvider>(context).getCartItems().isNotEmpty?Container(
              height: 20.h,
                width: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red
                ),
                child: Center(child: Text("${Provider.of<CartProvider>(context).getCartItems().length}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))):SizedBox()
          ])
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: (value) {
          _onBottomNavItemTap(value);
          setState(() {
            if (value == 0) {
              appBarTitle = "Home Page";
            } else if (value == 1) {
              appBarTitle = "My Profile";
            }
          });
        },
      ),
    );
  }
}
