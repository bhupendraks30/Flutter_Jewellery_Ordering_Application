import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/graph_data.dart';
import '../models/sold_data_item.dart';

class SoldDataProvider with ChangeNotifier{
  List<SoldDataItem> _listOfSoldProduct =[];

  SoldDataProvider(){
    // loading the sold data from shared preferences
    loadSoldData();
  }

//   get all the sold product items
  List<SoldDataItem> getSoldData()=>_listOfSoldProduct;

// load all the sold data from shared preferences
void loadSoldData()async{
  final sharedPref = await SharedPreferences.getInstance();
  String? strListData = sharedPref.getString("SOLD_PRODUCTS_DATA");
  if(strListData!=null){
    List decodedListData = jsonDecode(strListData);
    _listOfSoldProduct = decodedListData.map((item)=>SoldDataItem.fromJson(item)).toList();
    notifyListeners();
  }else{
    _listOfSoldProduct=[];
    notifyListeners();
  }
}

void saveSoldData()async{
    final sharedPref = await SharedPreferences.getInstance();
    if(_listOfSoldProduct.isEmpty){
      return;
    }
    //     converting all the list of SoldDataItem into list of json object
    List encodedData = _listOfSoldProduct.map((item)=>item.toJson()).toList();
    //     converting the list of map data into string data
    String strData = jsonEncode(encodedData);
    //   storing the data into shared preferences
    await sharedPref.setString("SOLD_PRODUCTS_DATA", strData);
  }

  void addSoldDataItem(SoldDataItem item){
    int index = _listOfSoldProduct.indexWhere((e)=>e.id==item.id);
    if(index!=-1){
      _listOfSoldProduct[index].quantity += item.quantity;
    }else{
      _listOfSoldProduct.add(item);
    }
    saveSoldData();
    notifyListeners();
  }

  List<GraphData> getGraphData(){
    List<GraphData> dataList =[];
    _listOfSoldProduct.forEach((item){
      dataList.add(GraphData(productName: item.title, count: item.quantity));
    });
    return dataList;
  }


}