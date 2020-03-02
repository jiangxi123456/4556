
import 'package:flutter/material.dart';
//ChangeNotifier 混入管理
class  Counter with ChangeNotifier{
  int value =1;
  increment () {
    value++;
    notifyListeners();//通知听众，值改变了，局部刷新
  }
}