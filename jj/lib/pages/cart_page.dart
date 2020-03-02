import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/cart.dart';
import 'cart_page/cart-item.dart';
import 'cart_page/cart_bottom.dart';
class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("购物车")
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context,snapshot){
           if(snapshot.hasData) {
              return Stack(
                children:<Widget>[
                  Provide<CartProvide>(
                    builder: (context,child,val){
                     List cartList = Provide.value<CartProvide>(context).cartList;
                        return  Container(
                          padding: EdgeInsets.only(bottom:ScreenUtil().setHeight(120)),
                          child:ListView.builder(
                            itemCount:cartList.length,
                            itemBuilder: (context,index){
                            return CartItem(cartList[index]);
                          })
                        );
                    }),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: CartBottom()
                      )
                  ]
              );
           } else {
             return Text('加载中');
           }
        }),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async{
    print('-----------------');
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}