import 'package:flutter/material.dart';
import '../model/category.dart';
import 'dart:convert'; //处理后台返回数据json
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/child_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart'; //下拉加载，刷新
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
   void iniState(){
      super.initState();
    
   }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: Text('商品分类',style: TextStyle(fontSize:20),),titleSpacing: 40),
      body: Container(
        child: Row(
            children: <Widget>[
              LeftCategoryNav(),
              Column(
                children: <Widget>[
                  _RightCategoryNav(),
                  CategoryGoodsList()
                ],
              )
            ],
        ),
      ),

    );
  }  
 

}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List<Data> list =[]; 
  var mallCategoryId = '';//大类id
  var listIndex = 0;
  @override
  void initState () {
    //此处掉两个接口异步执行跑【-0p-+-
     Future(()=> _getCategory())
    .then((_)=> _getGoodOneList());
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(210),
      decoration: BoxDecoration(
        border:Border(
          right:BorderSide(width:1,color:Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder:(context,index){
            return _leftInkWell(index);
        },
      )
    );
  }
  Widget _leftInkWell(int index) {
      bool isClick = false;
      isClick = listIndex==index?true:false;
    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList =list[index].bxMallSubDto;
        //获取大类的id
        String categoryId = list[index].mallCategoryId; 
        Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);//点击存储二类导航
        _getGoodOneList(categoryId:list[index].mallCategoryId);
      },
      child: Container( 
        // height:ScreenUtil().setHeight(130) ,也不需要设置高度，padding撑开
        padding: EdgeInsets.only(left:10, top:10,bottom:10),
        decoration: BoxDecoration(
          color:isClick?Color.fromRGBO(236, 236, 236, 1.0):Colors.white,
          border:Border(bottom:BorderSide(width:1,color:Colors.black12))
        ),
        child: Text(list[index].mallCategoryName,style:TextStyle(fontSize: ScreenUtil().setSp(28))),
      ),
    );
  }
  //获取大类
  void  _getCategory()async{
    await request('getCategory').then((val){
          var data = json.decode(val.toString());
        CategoryModel category = CategoryModel.fromJson(data);
       setState(() {
         list=category.data;
         mallCategoryId=category.data[0].mallCategoryId;//默认第一个大类
       });
        //初始化二级分类
        //
        List childCategory  = list[0].bxMallSubDto;
        Provide.value<ChildCategory>(context).getChildCategory(childCategory,mallCategoryId);
        print(11);
    });
  }
  //获取商品列表
  void _getGoodOneList({String categoryId}) async{
   var data={
      'categoryId':categoryId==null?mallCategoryId:categoryId,
      'categorySubId':"",
      'page':1
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

class _RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<_RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return 
    Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return   Container(
      height: ScreenUtil().setHeight(90),
      width:ScreenUtil().setWidth(540) ,
      decoration: BoxDecoration(
        color:Colors.white,
        border:Border(
          bottom:BorderSide(width:1,color:Colors.black12)
        )
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:childCategory.childCategoryList.length ,
        itemBuilder:(context,index){
         
          return _rightInkWell(index,childCategory.childCategoryList[index]);
        }),
    );
      }
    );
   
  }

  Widget _rightInkWell(int index,BxMallSubDto item) {
    bool isClick = false;
    isClick = index==Provide.value<ChildCategory>(context).childindex?true:false;
    return InkWell(
      onTap:(){
         //改变二级导航选择的颜色
         Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
         _getGoodList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize:ScreenUtil().setSp(28),
            color:isClick?Colors.pink:Colors.black),
        ),
      ),
    );
  }

  //获取商品列表(点击二级导航获得)
  void _getGoodList(String categorySubId) async{
   var data={
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
       
        if(goodsList.data==null) {
            Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
        } else {
            Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data); 
        }
        
    });
  }


}
//商品列表，可以上拉加载
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
var scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
    Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        try{
          if(Provide.value<ChildCategory>(context).page==1) {
            //列表位置，放到最上边
              scrollController.jumpTo(0.0);
          }
        }catch(e){
          // print('页面第一次初始化:${e}');
        }
        if(data.goodsList.length>0) {
            return Expanded(//Expanded具有伸缩能力不需要定制高度解决溢出
              child: Container(
                width: ScreenUtil().setWidth(500),
                // height: ScreenUtil().setHeight(1000),

                child: EasyRefresh(
                  child: ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.only(top:0),
                        itemCount: data.goodsList.length,
                        itemBuilder: (context,index){
                          return _listItem(data.goodsList,index);
                      }),
                  onRefresh: () async{
                    print('onRefresh');
                    _getRefreshGoodList();
                  },
                  onLoad: () async {
                    print('onLoad');
                    _getMoreGoodList();
                  },
                header: BallPulseHeader(),
                footer: BallPulseFooter(),

                ),
                
               
            ),
            );
        }
        else {
            return Text("暂时无数据");
        }
      },
    );
     
  }
   //获取商品列表(下拉刷新)
  void _getRefreshGoodList() async{
    Provide.value<ChildCategory>(context).addPage();
   var data={
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':1
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
        if(goodsList.data==null) {
            Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
        } else {
            Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data); 
        }
        
    });
  }

   //获取商品列表(加载更多)
  void _getMoreGoodList() async{
    Provide.value<ChildCategory>(context).addPage();
   var data={
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
     
        if(goodsList.data==null) {
            Fluttertoast.showToast(
                msg: "没有更多",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
                fontSize: 16.0
            );
           Provide.value<ChildCategory>(context).changeNoMore('没有更多');
        } else {
            Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data); 
        }
        
    });
  }

  
  Widget _goodsImages(List newList,int index) {
      return Container(
       width: ScreenUtil().setWidth(170),
        child:Image.network(newList[index].image)
      );
  }

  Widget _goodsName(List newList,int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(290),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize:ScreenUtil().setSp(28)),
        ),
    );
  }

  Widget _goodsPrice(List newList,index) {
    return Container(
      margin: EdgeInsets.only(top:10),
      width: ScreenUtil().setWidth(320),
      child: Row(
        children:<Widget>[
          Text('价格：￥${newList[index].presentPrice}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color:Colors.pink,fontSize:ScreenUtil().setSp(26)),),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,
            decoration: TextDecoration.lineThrough),
          )
        ]
      ),
    );
  }
  
  Widget _listItem(List newList,int index) {
    return InkWell(
      onTap:(){},
      child: Container(
        padding: EdgeInsets.only(top:10.0,bottom:10.0),
        decoration: BoxDecoration(
          color:Colors.white,
          border:Border(
            bottom:BorderSide(width:1,color:Colors.black12)
          )
        ),
        child:Row(
          children:<Widget>[
            _goodsImages(newList,index),
            Column(
              children:<Widget>[
                _goodsName(newList,index),
                _goodsPrice(newList,index)
              ]
            )
          ]
        )
      ),
    );
  }
}

