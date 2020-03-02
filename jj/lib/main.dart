

import 'package:flutter/material.dart';//谷歌的风格
import 'package:flutter/cupertino.dart';//ios风格
import 'pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/child_goods_list.dart';
import './provide/details_info.dart';
import 'package:fluro/fluro.dart';//路由管理
import './routers/routers.dart';//路由配置文件
import './routers/application.dart';
import 'provide/cart.dart';
import 'provide/currentIndex.dart';//静态化
void main(){
  final router  = new Router();
  Routes.configureRoutes(router);//Routes 是routers.dart里面的一个类
  Application.router = router;
  
  var counter =Counter();
  var childCategory =ChildCategory();
  var categoryGoodsListProvide =  CategoryGoodsListProvide();
  var detailsInfoProvid = DetailsInfoProvid();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers = Providers();
  providers
    ..provide(Provider<Counter>.value(counter))
     ..provide(Provider<CartProvide>.value(cartProvide))
     ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
     ..provide(Provider<DetailsInfoProvid>.value(detailsInfoProvid))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<ChildCategory>.value(childCategory));//多个继续点点
  runApp(ProviderNode(child:MyApp(),providers:providers));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,//路由静态化
        debugShowCheckedModeBanner: false,//去掉屏幕右上角bug
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}