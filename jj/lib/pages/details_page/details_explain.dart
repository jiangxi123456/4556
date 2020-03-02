import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class DetailsExplain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      margin: EdgeInsets.only(top:10),
      padding: EdgeInsets.all(10),
      width: ScreenUtil().setWidth(750),
      child: Text(
        '说明：>技术送达>正品保障',
        style:TextStyle(fontSize: ScreenUtil().setSp(26))
      ),
    );
  }
}