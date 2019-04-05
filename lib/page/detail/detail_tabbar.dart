import 'package:baixing/page/detail/detail_command.dart';
import 'package:baixing/page/detail/detail_web.dart';
import 'package:baixing/provider/goods_info.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Provide<DetailsInfoProvide>(builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;
        return Container(
          height: ScreenUtil().setHeight(1100),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _myTabBarLeft(context, isLeft),
                  _myTabBarRight(context, isRight)
                ],
              ),

        Expanded(child:              Container(
                child: isLeft
                    ? DetailWebDetail()
                    : DetailCommandDetail()
              ),),
            ],
          ),
        );
      }),
    );
  }

  Widget _myTabBarLeft(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        child: Text(
          '详情',
          style: getTS(isLeft),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft ? Colors.pink : Colors.black12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _myTabBarRight(BuildContext context, bool isLeft) {
    return InkWell(
      onTap: () {
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        child: Text(
          '评论',
          style: getTS(isLeft),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isLeft ? Colors.pink : Colors.black12,
            ),
          ),
        ),
      ),
    );
  }

  TextStyle getTS(bool flag) {
    return TextStyle(color: flag ? Colors.pink : Colors.black);
  }
}
