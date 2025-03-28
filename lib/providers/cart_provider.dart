import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item.dart';

class CartProvider with ChangeNotifier{
  List<CartItem> _cartItemList = [];
  String? _userId;

  CartProvider(){
    FirebaseAuth.instance.authStateChanges().listen((event) {
      _userId = event?.uid;
      loadCartItems();
      notifyListeners();
    },);
  }

  // return the cartItem list
    List<CartItem> getCartItems()=>_cartItemList;
  // this method fetch the added cart data from shared preferences
  Future<void> loadCartItems()async{
    if (_userId==null)
      return;
    final sharedPref = await SharedPreferences.getInstance();
    String? stringCardData = sharedPref.getString("cart_$_userId");
    if(stringCardData!=null && stringCardData.isNotEmpty){
      //   convert the string data into List json
      final List decodeList = jsonDecode(stringCardData);
    //   converting the list of json value into the list of Cart Item
      _cartItemList = decodeList.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }else{
    //   set Empty tha list
      _cartItemList = [];
      notifyListeners();
    }
  }

//   save data to shared preference
  Future<void> saveCartData()async{
    final sharedPref = await SharedPreferences.getInstance();
    if (_cartItemList.isEmpty){
      await sharedPref.setString("cart_$_userId","");
      return;
    }


    // converting this into the list of Map or json value
    List jsonListData = _cartItemList.map((e)=>e.toJson()).toList(); // here the e is CartItem object
  //   encode the json list data into string so that it can stored in shared preferences
    String? stringCartData = jsonEncode(jsonListData);
  //   storing the data into shared preference
    await sharedPref.setString("cart_$_userId", stringCartData);
  }

//  adding the cart Item
  void addToCart(CartItem cartItem){
    int index = _cartItemList.indexWhere((element)=>element.id==cartItem.id);
    if(index!=-1){
      _cartItemList[index].quantity +=1;
    }else{
      _cartItemList.add(cartItem);
    }
    Fluttertoast.showToast(msg: "Add to cart.");
    saveCartData();
    notifyListeners();
  }

//  removing the cart Item
  void removeFromCart(int productId){
    int index = _cartItemList.indexWhere((element)=>element.id==productId);
    _cartItemList.removeAt(index);
    saveCartData();
    notifyListeners();
  }

//  update the quantity of the product item that is exist into the cart list data
  void updateQuantity(int productId,int newQuantity){
    int index =_cartItemList.indexWhere((element)=>element.id==productId);
    if(index!=-1){
      _cartItemList[index].quantity=newQuantity;
      notifyListeners();
    }
    saveCartData();
  }

//   returns the total price of products
  double totalPrice(){
    double sum = 0;
    for (int i=0; i<_cartItemList.length;i++){
      sum = sum + _cartItemList[i].price*_cartItemList[i].quantity;
    }
    return sum.ceilToDouble();
  }

//   clear cart item
  void clear(){
    _cartItemList = [];
    saveCartData();
    notifyListeners();
  }
}