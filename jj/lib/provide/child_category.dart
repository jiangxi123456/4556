


import 'package:flutter/material.dart';
import '../model/category.dart';
//ChangeNotifier 混入管理
class  ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];
  int childindex = 0;//子类高亮索引
  String categoryId = '';//大类的默认id
  String subId = '';//小类id
  int page  = 1;//列表页数
  String noMoreText = ''; //显示没有数据的文字
 //大类切换
  getChildCategory(List<BxMallSubDto> list,String id){
      page = 1;
      noMoreText = '';
      categoryId = id;//改变大类的id
      childindex = 0;//大类切换重置0
      BxMallSubDto all = BxMallSubDto();
      all.mallSubId='';
      all.mallCategoryId='00';
      all.comments='null';
      all.mallSubName='全部';
      childCategoryList=[all];
      childCategoryList.addAll(list);
      notifyListeners();
  } 
  //改变子类索引
  changeChildIndex(index,String id){
      page = 1;
      noMoreText = '';
      childindex = index; 
      subId = id;
      notifyListeners();
  }
  //增加page的方法
  addPage(){
    page++;
  }
  //改变noMoreText
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}