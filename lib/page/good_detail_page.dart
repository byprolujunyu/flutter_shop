import 'dart:convert';
import 'package:baixing/page/detail/detail_expand.dart';
import 'package:baixing/page/detail/detail_tabbar.dart';
import 'package:baixing/page/detail/detail_web.dart';
import 'package:baixing/page/detail/detail_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:baixing/model/details.dart';
import 'package:baixing/provider/goods_info.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

class GoodDetailPage extends StatelessWidget {
  final String goodsId;

  GoodDetailPage({@required this.goodsId});

  DetailsModel model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            print('返回上一页');
            Navigator.pop(context);
          },
        ),
        title: Text('商品详细页'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
                child:ListView(
                  children: <Widget>[
                    //关键代码------start
                    D(),

                    DetailsExplain(),

                    DetailsTabbar(),

                   DetailWebDetail(),
                    //关键代码------end
                  ],
                )
            );
          } else {
            return Container(child: Loading(),);
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '完成加载';
  }
}
