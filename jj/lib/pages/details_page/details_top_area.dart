import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvid>(
      builder: (context,child,val){
          var info = Provide.value<DetailsInfoProvid>(context).goodsInfo.data.goodInfo;
          if(info!=null) {
              return Container(
                color: Colors.white,
                child: Column(
                  children:<Widget>[
                    _goodsImage(info.image1),
                    _goodsName(info.goodsName),
                    _goodsNum(info.goodsSerialNumber)
                  ]
                ),
              );
          }
          else {
            return Text('正在加载中');
          }
          
      },
    );
   
  }
  //商品图片
  Widget _goodsImage(url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(740),
      );
  }
  //商品名称
  Widget _goodsName(name) {
    return Container(
      width: ScreenUtil().setWidth(740),
      padding: EdgeInsets.only(left:15),
      child: Text(name,
      style: TextStyle(
        fontSize:ScreenUtil().setSp(30)
        ),),
    );
  }

  //商品编号
  Widget _goodsNum(num) {
    return Container(
      width: ScreenUtil().setWidth(730),
      padding: EdgeInsets.only(left:15),
      margin: EdgeInsets.only(top:10),
      child: Text(
        '编号: ${num}',
        style:TextStyle(
          color:Colors.black45
        )
        ),
    );
  }
}