import 'package:flutter/material.dart';
import 'dart:convert'; //处理后台返回数据json
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart'; //拨打电话发邮件
import 'package:flutter_easyrefresh/easy_refresh.dart'; //下拉加载，刷新
import 'package:flutter_easyrefresh/ball_pulse_header.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import '../routers/application.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  List<Map> hotGoodsList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};

    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Container(
        child: FutureBuilder(
          //解决异步请求页面显示组件
          future: request('homePageContext', formData: formData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              // print(data);
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String adpic = data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String leaderImg = data['data']['shopInfo']['leaderImage']; //店长图片
              String leaderTel = data['data']['shopInfo']['leaderPhone']; //店长电话
              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast(); // 商品推荐
              String floor1Title =
                  data['data']['floor1Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              String floor2Title =
                  data['data']['floor2Pic']['PICTURE_ADDRESS']; //楼层1的标题图片
              List<Map> floor1 =
                  (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 =
                  (data['data']['floor2'] as List).cast(); //楼层1商品和图片
              //SingleChildScrollView 换成ListView
              return EasyRefresh(
                //EasyRefresh下拉，上拉

                header: BallPulseHeader(),
                footer: BallPulseFooter(),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: swiper),
                    TopNaigator(navigatorList: navigatorList),
                    Adbanner(adpicture: adpic),
                    LeaderPhone(leaderImage: leaderImg, leaderPhone: leaderTel),
                    Recommend(recommendList: recommendList),
                    FloorTitle(picaddress: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(picaddress: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    _hotGoods()
                  ],
                ),
                onLoad: () async {
                  print('加载更多');
                  var formData = {'page': page};
                  await request('homePageBelowConten', formData: formData)
                      .then((res) {
                    var data = json.decode(res.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
                onRefresh: () async {
                  print('下拉刷新');
                  await request('homePageContext', formData: formData);
                },
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ),
      ),
    );
  }

  // void _getHotGoodsList(formData) {
  //   request('homePageBelowConten', formData: formData).then((res) {
  //     var data = json.decode(res.toString());
  //     List<Map> newGoodsList = (data['data'] as List).cast();
  //     setState(() {
  //       hotGoodsList.addAll(newGoodsList);
  //     });
  //   });
  // }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[hotTitle(), _warpList()],
      ),
    );
  }

  //火爆专区标题
  Widget hotTitle() => Container(
        margin: EdgeInsets.only(top: 10),
        alignment: Alignment.center,
        color: Colors.transparent, //背景颜色透明色
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(
          '火爆专区',
        ),
      );

  Widget _warpList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWiget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            Application.router.navigateTo(context,"/detail?id=${val['goodsId']}");
          },
          highlightColor: Colors.transparent, //此处禁用水波纹背景透明
          radius: 0.0, //此处禁用水波纹圆角
          child: Container(
            width: ScreenUtil().setWidth(350),
            // color: Colors.white,//不能与decoration同时存在背景颜色定义在 decoration color中
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white),
            // margin: EdgeInsets.only(bottom: 10),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text('￥${val['mallPrice']}'),
                    ),
                    Text(
                      '￥${val['peice']}',
                      style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: listWiget,
      );
    } else {
      return Text('无内容');
    }
  }
}

//两排点击
class TopNaigator extends StatelessWidget {
  final List navigatorList;
  TopNaigator({Key key, this.navigatorList}) : super(key: key);
  Widget _gridViewItemUI(BuildContext context, item) {
    return 
      InkWell(
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.red,
        highlightColor: Colors.grey,
        onTap: () {},
        child: Column(
          children: <Widget>[
            Image.network(
              item['image'],
              width: ScreenUtil().setWidth(95),
            ),
            Text(item['mallCategoryName'],
            style: TextStyle(fontSize: ScreenUtil().setSp(24)),
            )
          ],
        ),
    );
    
    
  }

  @override
  Widget build(BuildContext context) {
    if (navigatorList.length > 10) {
      navigatorList.removeRange(10, navigatorList.length); //保留前十个
    }
    return Container(
      height: ScreenUtil().setHeight(380),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        mainAxisSpacing:5,
        crossAxisSpacing: 5,
        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//首页轮播
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  // SwiperDiy(this.swiperDataList);//简洁构造方法
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            "${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
}

//广告位
class Adbanner extends StatelessWidget {
  final String adpicture;
  Adbanner({Key key, this.adpicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adpicture),
    );
  }
}

//拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          _launchURL();
        },
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '不能进行访问';
    }
  }
}

//商品推荐

class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({Key key, this.recommendList}) : super(key: key);
  //标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft, //居中靠左对齐
      padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 0.1, color: Colors.black))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //商品方法
  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: ScreenUtil().setWidth(240),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(left: BorderSide(width: 1, color: Colors.grey))
            ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12,
                  color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  //横向列表
  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(380),
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, //横向
        itemCount: recommendList.length,
        itemBuilder: (context, index) {
          return _item(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(480),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[_titleWidget(), _recommedList()],
        ));
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String picaddress;
  FloorTitle({Key key, this.picaddress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(picaddress),
    );
  }
}
//楼层商品列表

class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          _fristRow(),
          _otherGoods(),
        ],
      ),
    );
  }

  Widget _fristRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2])
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(350),
      child: InkWell(
        onTap: () {},
        child: Image.network(goods['image']),
      ),
    );
  }
}
