import 'package:baixing/model/details.dart';
import 'package:baixing/page/detail/detail_num.dart';
import 'package:baixing/provider/goods_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

class CountWidget extends StatefulWidget {
  final goodDetail;

  CountWidget({this.goodDetail});

  @override
  _CountWidgetState createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  bool flag = true;

  @override
  void initState() {
    setState(() {
      flag = true;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(builder: (context, child, val) {
      DetailsModel goodsInfo = val.goodsInfo;
      return Container(
        width: ScreenUtil.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: InkWell(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(50),
                        child: Image.asset('img/icon_detai;_page_cart.png'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: ScreenUtil().setWidth(30),
                        height: ScreenUtil().setHeight(30),
                        child: Text(
                          '99',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(10),
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ],
                    alignment: FractionalOffset(0.999, 0.001),
                  ),
                ),
                onTap: () {},
              ),
            ),
            Expanded(
              flex: 7,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => NumCountWidget(
                          remove: (context) {
                            setState(() {
                              flag = false;
                            });
                            Navigator.pop(context);
                          },

                      detailModel: goodsInfo,
                        ),
                  );
                },
                child: Container(
                  height: ScreenUtil().setHeight(100),
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      '加入购物车',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: InkWell(
                onTap: () {},
                child: Container(
                  height: ScreenUtil().setHeight(100),
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      '立即购买',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
