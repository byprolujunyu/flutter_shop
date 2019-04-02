import 'package:baixing/routers/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/service_method.dart';
import '../model/category.dart';
import '../provider/child_category.dart';
import '../model/categoryGoods.dart';
import '../provider/category_goods_list.dart';

jumpDetail(@required context, @required id) {
  Application.router.navigateTo(context, '/detail?id=$id',
      transition: TransitionType.fadeIn);
}

class CatePage extends StatefulWidget {
  _CatePageState createState() => _CatePageState();
}

class _CatePageState extends State<CatePage> {
  List<CategoryModel> list;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("商品分类"),
        ),
        body: Row(
          children: <Widget>[
            LeftCategory(),
            Column(
              children: <Widget>[
                RightC(),
                CatrgoryGoods(),
              ],
            )
          ],
        ));
  }
}

//  左侧导航
class LeftCategory extends StatefulWidget {
  _LeftCategoryState createState() => _LeftCategoryState();
}

class _LeftCategoryState extends State<LeftCategory> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
    _getGoodsList();
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };

    await request('getMallGoods', formData: data).then((res) {
      var data = json.decode(res.toString());
      CategoryGoddsModel goodsList = CategoryGoddsModel.fromJson(data);
      print("------------------------------>>>>>获取成功：${data}");

      Provide.value<CategoryGoodsProvide>(context).getGoodsList(goodsList.data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: ScreenUtil().setWidth(180),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 1, color: Colors.black12))),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return _leftInkWell(index);
          },
        ));
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChild(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text("${list[index].mallCategoryName}"),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      print("------------------->>>>开始获取分类数据");
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context)
          .getChild(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }
}

// 右边的导航

class RightC extends StatefulWidget {
  _RightCState createState() => _RightCState();
}

class _RightCState extends State<RightC> {
  Widget _Item(BxMallSubDto item, int index) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex)
        ? true
        : false;

    return InkWell(
      onTap: () {
        if (!isClick) {
          Provide.value<ChildCategory>(context)
              .changeChildenIndex(index, item.mallSubId);
          _getGoodsList(item.mallSubId);
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCate) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCate.childCategory.length,
            itemBuilder: (context, index) {
              return _Item(childCate.childCategory[index], index);
            },
          ),
        );
      },
    );
  }

  void _getGoodsList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };

    await request('getMallGoods', formData: data).then((res) {
      var data = json.decode(res.toString());
      CategoryGoddsModel goodsList = CategoryGoddsModel.fromJson(data);
      print("------------------------------>>>>>获取成功：${data}");

      if (goodsList.data == null) {
        Provide.value<CategoryGoodsProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsProvide>(context)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

// 商品列表
class CatrgoryGoods extends StatefulWidget {
  _CatrgoryGoodsState createState() => _CatrgoryGoodsState();
}

class _CatrgoryGoodsState extends State<CatrgoryGoods> {
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

  var scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsProvide>(
      builder: (context, child, data) {
        try {
          if (Provide.value<ChildCategory>(context).page == 1) {
            // 列表位置置顶
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          // 第一次进入页面加载.......
          print("第一次初始化....${e}");
        }

        if (data.goodslist.length > 0) {
          return Expanded(
              child: Container(
                  width: ScreenUtil().setWidth(570),
                  child: EasyRefresh(
                    refreshFooter: ClassicsFooter(
                        key: _footerKey,
                        bgColor: Colors.white,
                        textColor: Colors.pink,
                        moreInfoColor: Colors.pink,
                        showMore: true,
                        noMoreText:
                            Provide.value<ChildCategory>(context).nomoreText,
                        moreInfo: '加载中',
                        loadReadyText: '上拉加载....'),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: data.goodslist.length,
                      itemBuilder: (context, index) {
                        return _listItem(data.goodslist, index);
                      },
                    ),
                    loadMore: () async {
                      print("上拉加载更多.....");
                      _getMoreList();
                    },
                  )));
        } else {
          return Text("暂时没有数据......");
        }
      },
    );
  }

  void _getMoreList() async {
    Provide.value<ChildCategory>(context).addPage();

    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    await request('getMallGoods', formData: data).then((res) {
      var data = json.decode(res.toString());
      CategoryGoddsModel goodsList = CategoryGoddsModel.fromJson(data);
      if (goodsList.data == null) {
        Fluttertoast.showToast(
            msg: "已经到底了.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.pink,
            textColor: Colors.white);
        Provide.value<ChildCategory>(context).changeNomore("没有更多了.....");
      } else {
        Provide.value<CategoryGoodsProvide>(context)
            .getMoreList(goodsList.data);
      }
    });
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrise(List newList, int index) {
    return Container(
        width: ScreenUtil().setWidth(370),
        margin: EdgeInsets.only(
          top: 20,
        ),
        child: Row(
          children: <Widget>[
            Text(
              "价格：￥${newList[index].presentPrice}",
              style: TextStyle(
                  color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
            ),
            Text(
              "￥${newList[index].oriPrice}",
              style: TextStyle(
                  color: Colors.black26,
                  decoration: TextDecoration.lineThrough),
            )
          ],
        ));
  }

  Widget _listItem(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: InkWell(
          child: Row(
            children: <Widget>[
              _goodsImage(newList, index),
              Column(
                children: <Widget>[
                  _goodsName(newList, index),
                  _goodsPrise(newList, index)
                ],
              )
            ],
          ),
          onTap: () {
            jumpDetail(context, newList[index].goodsId);
          },
        ),
      ),
    );
  }
}
