


import 'package:flutter/material.dart';
import '../model/categoryGoodsList.dart';
//ChangeNotifier 混入管理
class  CategoryGoodsListProvide with ChangeNotifier{
  List<CategoryListData> goodsList = [];
  //点击大类更换商品列表
  getGoodsList(List<CategoryListData> list){
      goodsList = list;
      notifyListeners();
  } 

  getMoreList(List<CategoryListData> list){
      //追加分页
      goodsList.addAll(list);
      notifyListeners();
  } 
}