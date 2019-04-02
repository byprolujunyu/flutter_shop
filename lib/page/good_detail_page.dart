import 'dart:convert';
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
            return Provide<DetailsInfoProvide>(
              builder: (context, child, data) {

                return data != null?Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(data.goodsInfo.data.goodInfo.image1),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: Text(
                            '${data.goodsInfo.data.goodInfo.goodsName}',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(40),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ):Container(child: Loading(),);
              },
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
