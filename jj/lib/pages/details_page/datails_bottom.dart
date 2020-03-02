import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import '../../provide/cart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/currentIndex.dart';
class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //加入购物车需要获取商品的基础信息
    var goodsInfo = Provide.value<DetailsInfoProvid>(context).goodsInfo.data.goodInfo;
    var goodsId= goodsInfo.goodsId;
    var goodsName =goodsInfo.goodsName;
    var count =1;
    var price =goodsInfo.presentPrice;
    var images= goodsInfo.image1;

    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(110),
      child: Row(
        children:<Widget>[
          Stack(
              children: <Widget>[
                  InkWell(
                    onTap:(){
                      Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                      Navigator.pop(context);
                    },
                    child:Container(
                      width:ScreenUtil().setWidth(110),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.shopping_cart,
                        size:35,
                        color:Colors.red
                      ),
                    )
                  ),
                  Provide<CartProvide>(builder: (context,child,val){
                      var  allGoodsCount =Provide.value<CartProvide>(context).allGoodsCount; 
                      return Positioned(
                        top: 0,
                        right:0,
                        child: Container(
                          width: ScreenUtil().setWidth(110),
                          height: ScreenUtil().setHeight(110),
                          alignment: Alignment.center,
                          child: Text(
                            '${allGoodsCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                            ),
                            ),
                        )
                        );
                  }),
                 
              ],
          ),
          
          InkWell(
            onTap:() async{
             await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images); 
            },
            child:Container(
              width:ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                  color:Colors.white,
                  fontSize:ScreenUtil().setSp(28)
                ),
              ),
            )
          ),
          InkWell(
            onTap:() async{
             await Provide.value<CartProvide>(context).remove(); 
            },
            child:Container(
              width:ScreenUtil().setWidth(320),
              alignment: Alignment.center,
              color: Colors.red,
              child: Text(
                '立即购买',
                style: TextStyle(
                  color:Colors.white,
                  fontSize:ScreenUtil().setSp(28)
                ),
              ),
            )
          )
        ]
      ),
    );
  }
}