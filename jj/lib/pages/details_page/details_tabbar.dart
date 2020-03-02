import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    
    return Provide<DetailsInfoProvid>(
      builder: (context,child,val){
        //  Provide.value<DetailsInfoProvid>(context).changeLeftAndRight('left');
        var isLeft  = Provide.value<DetailsInfoProvid>(context).isLeft;
        var isRight  = Provide.value<DetailsInfoProvid>(context).isRight;
        return Container(
          margin: EdgeInsets.only(top:15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget>[
                _myTabBarLeft(context,isLeft),
                _myTabBarRight(context,isRight)  
            ]
          ),
        );
      },
    );
  }
  //左侧
  Widget _myTabBarLeft(BuildContext context,bool isleft) {
      return InkWell(
        onTap: (){
            Provide.value<DetailsInfoProvid>(context).changeLeftAndRight('left');
        },
        child: Container(
          padding:EdgeInsets.all(10),
          alignment: Alignment.center,
          width:ScreenUtil().setHeight(375),
          decoration: BoxDecoration(
            color:Colors.white,
            border:Border(
              bottom:BorderSide(
                width:1,
                color:isleft?Colors.pink:Colors.black12
              )
            )
          ),
          child: Text(
            '详情',
            style: TextStyle(
              color:isleft?Colors.pink:Colors.black45
            ),
          ),
        ),
      );
  }

  //右侧

  Widget _myTabBarRight(BuildContext context,bool isRight) {
      return InkWell(
        onTap: (){
            Provide.value<DetailsInfoProvid>(context).changeLeftAndRight('right');
        },
        child: Container(
          padding:EdgeInsets.all(10),
          alignment: Alignment.center,
          width:ScreenUtil().setHeight(375),
          decoration: BoxDecoration(
            color:Colors.white,
            border:Border(
              bottom:BorderSide(
                width:1,
                color:isRight?Colors.pink:Colors.black12
              )
            )
          ),
          child: Text(
            '评论',
            style: TextStyle(
              color:isRight?Colors.pink:Colors.black45
            ),
          ),
        ),
      );
  }
}