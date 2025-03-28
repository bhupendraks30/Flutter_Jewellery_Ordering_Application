import 'package:flutter/material.dart';

class SoldDataItem{
  int id;
  String title;
  int quantity;

  SoldDataItem(this.id, this.title, this.quantity);

  Map<dynamic,dynamic> toJson(){
    return{
      'id': id,
      'title':title,
      'quantity':quantity
    };
  }

  factory SoldDataItem.fromJson(Map<dynamic,dynamic> json){
    return SoldDataItem(json['id'], json['title'], json['quantity']);
  }
}