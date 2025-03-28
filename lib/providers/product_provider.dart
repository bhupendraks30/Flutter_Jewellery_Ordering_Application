import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import '../models/product_item.dart';

class ProductProvider with ChangeNotifier{
  List<ProductItem> _productList = [];

  ProductProvider(){
    loadProduct();
  }

//   this method return the list of products
  List<ProductItem> getProductList()=>_productList;

//   this method fetch the product data
  Future<void> loadProduct()async{
    try{
      final response = await get(
          Uri.parse('https://fakestoreapi.com/products/category/jewelery'));
      if(response.statusCode==200){
        List jsonListData = jsonDecode(response.body);
        //   converting the json list data into object
        _productList = jsonListData.map((element)=>ProductItem.fromJson(element)).toList();
        notifyListeners();
      }
    }catch (e){
      print(e);
    }


  }

//   this method is use for fetch the product data
  ProductItem? getProduct(int productId){
    int index = _productList.indexWhere((element)=>element.id==productId);
    if(index!=-1){
      return _productList[index];
    }else{
      return null;
    }
  }
}