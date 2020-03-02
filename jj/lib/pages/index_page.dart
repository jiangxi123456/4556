

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_page.dart';
import 'category_page.dart';
import 'home_page.dart';
import 'member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/currentIndex.dart';

class IndexPage extends StatelessWidget {
  bool get wantKeepAlive =>true;
  final List<BottomNavigationBarItem> bottomTabs=[
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search,color: Colors.blue),
      title: Text('分类')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车')
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('个人中心')
    )
  ];
  final List<Widget> tabBodies = [
    HomePage(),
     CategoryPage(),
    CartPage(),
    MemberPage(),
  ];
 
  @override
  Widget build(BuildContext context) {
     //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
    ScreenUtil.init(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
     
     return  Provide<CurrentIndexProvide>(
       builder: (context,child,val){
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
       return Scaffold(
        backgroundColor: Colors.red,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,//定位
          currentIndex: currentIndex,
          items: bottomTabs,
          onTap: (index) {
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
          },
        ),
        body:IndexedStack(
          index:currentIndex,
          children:tabBodies,
        )
      );
     });
     
     
  }
}


// class IndexPage extends StatefulWidget {
//   @override
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> with AutomaticKeepAliveClientMixin{//保持状态
//    @override
//   bool get wantKeepAlive =>true;
//   final List<BottomNavigationBarItem> bottomTabs=[
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.home),
//       title: Text('首页'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.search,color: Colors.blue),
//       title: Text('分类')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.shopping_cart),
//       title: Text('购物车')
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.profile_circled),
//       title: Text('个人中心')
//     )
//   ];
//   final List<Widget> tabBodies = [
//     HomePage(),
//      CategoryPage(),
//     CartPage(),
//     MemberPage(),
//   ];
//   int currentIndex = 0;
//   var currenPage;
//   @override
//   void initState() {
//     currenPage = tabBodies[currentIndex];
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     //设置适配尺寸 (填入设计稿中设备的屏幕尺寸) 此处假如设计稿是按iPhone6的尺寸设计的(iPhone6 750*1334)
//     ScreenUtil.init(context);
//     ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     return Scaffold(
//       backgroundColor: Colors.red,
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,//定位
//         currentIndex: currentIndex,
//         items: bottomTabs,
//         onTap: (index) {
//           this.setState((){
//               currentIndex=index;
//               currenPage = tabBodies[currentIndex];
//           });
//         },
//       ),
//       body:IndexedStack(
//         index:currentIndex,
//         children:tabBodies,
//       )
//     );
//   }
// }