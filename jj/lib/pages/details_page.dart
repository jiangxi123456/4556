import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import 'details_page/datails_bottom.dart';
import 'details_page/details_explain.dart';
import 'details_page/details_tabbar.dart';
import 'details_page/details_top_area.dart';
import 'details_page/details_web.dart';
class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon:Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('商品详情页'),
      ),
      body:
       FutureBuilder(
        future:_getBackInfo(context),
        builder: (context,snapshot){
            if(snapshot.hasData) {
             return Stack(
                children:<Widget>[
                    Container(
                    padding: EdgeInsets.only(bottom:ScreenUtil().setHeight(110)),
                    width: ScreenUtil().setWidth(750),
                    child: ListView(
                      children:<Widget>[
                        DetailsTopArea(),
                        DetailsExplain(),
                        DetailsTabbar(),
                        DetailsWeb(),
                      ]
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: DetailsBottom(),
                  )
                ]
              );
            }
            else {
              return Text('加载中');
            }
        }
      ),
    );
  }
  Future _getBackInfo(BuildContext context) async{
    await Provide.value<DetailsInfoProvid>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}