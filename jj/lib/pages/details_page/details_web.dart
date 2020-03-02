import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail  = Provide.value<DetailsInfoProvid>(context).goodsInfo.data.goodInfo.goodsDetail;
    return
      Provide<DetailsInfoProvid>(
        builder: (context,child,val){
            var isleft = Provide.value<DetailsInfoProvid>(context).isLeft;
            if(isleft) {
              return  Container(
                child:Html(
                  data: goodsDetail
                  )
              );
            } else {
              return Container(
                width: ScreenUtil().setWidth(750),
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text('暂时没有评论',),
              );
            }
        },
      );
    
  }
}