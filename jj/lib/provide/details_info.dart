import 'package:flutter/material.dart';
import 'dart:convert'; //处理后台返回数据json
import '../service/service_method.dart';
import '../model/details.dart';
class DetailsInfoProvid with ChangeNotifier{
  DetailsModel goodsInfo  = null;
  bool isLeft = true;
  bool isRight = false;
  //从后台获取数据
  getGoodsInfo(String id)async{
    var formData = { 'goodId':id};
   await request('getGoodDetailById',formData:formData).then((val){
      var responseData = json.decode(val.toString());
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
  //tabbar切换
  changeLeftAndRight(String changeState) {
    if(changeState=='left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }
}