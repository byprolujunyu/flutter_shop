import 'package:baixing/model/details.dart';
import 'package:baixing/provider/goods_info.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:common_utils/common_utils.dart';

class DetailCommandDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<GoodComments> goodsCommand =
        Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodComments;
    var goodsPic = Provide.value<DetailsInfoProvide>(context)
        .goodsInfo
        .data
        .advertesPicture
        .pICTUREADDRESS;
    print(goodsPic);
    return Container(
      height: ScreenUtil().setHeight(2000),      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            getCommendsList(goodsCommand, context),
            Image.network(goodsPic.toString()),
          ],
        ),
      ),
    );
  }

  Widget item(BuildContext context, GoodComments goodsCommand, index) {
    var time = convert(goodsCommand.discussTime);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('${goodsCommand.userName}'),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('${goodsCommand.comments}'),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          child: Text('${time}'),
        ),
      ],
    );
  }

  Widget getCommendsList(ms, context) {
    if (ms.length != 0) {
      return Container(
        height: ms.length * MediaQuery.of(context).size.height / 7,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return item(context, ms[index], index);
          },
          itemCount: ms.length,
        ),
      );
    } else {
      return Container(
        child: Text('暂时还没有评论噢!'),
        margin: EdgeInsets.only(top: 15.0),
      );
    }
  }

  String convert(int date) {
    //var def = DateFormat.DEFAULT;
    var dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    var zhWeekDayByMs = DateUtil.getDateStrByDateTime(dateTime,
        format: DateFormat.YEAR_MONTH_DAY_HOUR_MINUTE);
    return zhWeekDayByMs;
  }
}
