import 'package:baixing/routers/application.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

jumpDetail(@required context, @required id) {
  Application.router.navigateTo(context, '/detail?id=$id',
      transition: TransitionType.fadeIn);
}

class HomePage extends StatefulWidget {
  final Widget child;

  HomePage({Key key, this.child}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据....';

  @override
  void initState() {
    super.initState();
    _getHotGoods();
  }

  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
        appBar: AppBar(
          title: Text("百姓生活+"),
        ),
        body: FutureBuilder(
          future: request("homePageContent", formData: formData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> swiper = (data['data']['slides'] as List).cast();
              List<Map> navigatorList =
                  (data['data']['category'] as List).cast();
              String advertesPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];

              String leaderImage = data['data']['shopInfo']['leaderImage'];
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];

              List<Map> recommendList =
                  (data['data']['recommend'] as List).cast();

              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor2'] as List).cast();
              List<Map> floor3 = (data['data']['floor3'] as List).cast();

              return EasyRefresh(
                //自定义foolter
                refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: '',
                    moreInfo: '加载中',
                    loadReadyText: '上拉加载....'),

                child: ListView(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDateList: swiper,
                    ),
                    TopNavigator(
                      navigatorList: navigatorList,
                    ),
                    AdBanner(
                      adPicture: advertesPicture,
                    ),
                    LeaderPhone(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(recommendList: recommendList),
                    FloorTitle(picture: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(picture: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    FloorTitle(picture: floor3Title),
                    FloorContent(floorGoodsList: floor3),
                    _hotGoods()
                  ],
                ),
                loadMore: () async {
                  var formPage = {'page': page};
                  await request('homePageBelowContent', formData: formPage)
                      .then((val) {
                    var data = json.decode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
              );
            } else {
              return Container(
                child: Center(
                  child: Loading(),
                ),
              );
            }
          },
        ));
  }

  void _getHotGoods() {
    var formPage = {'page': page};
    request('homePageBelowContent', formData: formPage).then((val) {
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 0.5, color: Colors.black12))),
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
            onTap: () {
              print('点击了火爆商品');
              jumpDetail(context, val['goodsId']);
            },
            child: Container(
              width: ScreenUtil().setWidth(372),
              color: Colors.white,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.only(bottom: 3.0),
              child: Column(
                children: <Widget>[
                  Image.network(
                    val['image'],
                    width: ScreenUtil().setWidth(375),
                  ),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['mallPrice']}'),
                      Text(
                        '￥${val['price']}',
                        style: TextStyle(
                            color: Colors.black26,
                            decoration: TextDecoration.lineThrough),
                      )
                    ],
                  )
                ],
              ),
            ));
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  Widget _hotGoods() {
    return Container(
        child: Column(
      children: <Widget>[
        hotTitle,
        _wrapList(),
      ],
    ));
  }
}

//首页轮播图
class SwiperDiy extends StatelessWidget {
  final Widget child;
  final List swiperDateList;

  SwiperDiy({Key key, this.child, this.swiperDateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              jumpDetail(context, swiperDateList[index]['goodsId']);
            },
            child: Image.network(
              "${swiperDateList[index]['image']}",
              fit: BoxFit.cover,
            ),
          );
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 顶部导航
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItem(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print("点击了子项。。");
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //10个导航
    if (navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }

    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item) {
          return _gridViewItem(context, item);
        }).toList(),
      ),
    );
  }
}

// 广告栏
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchUrl,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchUrl() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "---打电话出错----------->>>>>Could not launch $url";
    }
  }
}

// 推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
   //   height: ScreenUtil().setHeight(415),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[_titleWidget(), _recommedList(context)],
      ),
    );
  }

  //商品推荐标题
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Text(
        "商品推荐",
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  //列表
  Widget _recommedList(context) {
    return InkWell(
      child: Container(
       height: ScreenUtil().setHeight(360),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(context, index);
          },
        ),
      ),
    );
  }

  Widget _item(context, index) {
    return Container(
    //  height: ScreenUtil().setHeight(360),
      width: ScreenUtil().setWidth(250),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(left: BorderSide(width: 0.5, color: Colors.black12))),
      child: InkWell(
        onTap: () {
          jumpDetail(context, recommendList[index]['goodsId']);
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.network(recommendList[index]['image']),
              Text('￥${recommendList[index]['mallPrice']}'),
              Text(
                '￥${recommendList[index]['price']}',
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 楼层组件
class FloorTitle extends StatelessWidget {
  final String picture;

  FloorTitle({Key key, this.picture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture),
    );
  }
}

// 楼层列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[_firstRow(context), _otherGoods(context)],
    ));
  }

  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0], context),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1], context),
            _goodsItem(floorGoodsList[2], context),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3], context),
        _goodsItem(floorGoodsList[4], context),
      ],
    );
  }

  Widget _goodsItem(Map goods, context) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
          jumpDetail(context, goods['goodsId']);
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}
