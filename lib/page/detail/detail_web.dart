import 'package:baixing/provider/goods_info.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailWebDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo.goodsDetail;
    var goodsPic = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.advertesPicture.pICTUREADDRESS;
    print(goodsPic);
    return Container(
      child:SingleChildScrollView(child:  Column(
        children: <Widget>[
          Html(data: goodsDetail),
          Image.network(goodsPic.toString()),
        ],
      ),)
    );
  }
}
