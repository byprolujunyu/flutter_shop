import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NumCountWidget extends StatefulWidget {
  final Function(BuildContext context) remove;

  NumCountWidget({@required this.remove});

  @override
  _NumCountWidgetState createState() => _NumCountWidgetState();
}

class _NumCountWidgetState extends State<NumCountWidget> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(180),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text('购买数量'),
                ),
                InkWell(
                  child: Container(
                    height: ScreenUtil().setHeight(50),
                    width: ScreenUtil().setWidth(50),
                    child: Image.asset(
                      'img/close.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  onTap: () {
                    widget.remove(context);
                  },
                ),
              ],
            ),
            Divider(
              height: 5,
              color: Colors.black26,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1, 3, 0, 3),
              child: Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => {_dix_count()},
                          child: Container(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(50),
                            alignment: Alignment.center,
                            child: Text(
                              '-',
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setWidth(50),
                          alignment: Alignment.center,
                          child: Text('$count'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.black26, width: 3),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => {_add_count()},
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setWidth(50),
                            alignment: Alignment.center,
                            child: Text(
                              '+',
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          height: ScreenUtil().setHeight(50),
                          width: ScreenUtil().setWidth(300),
                          alignment: Alignment.center,
                          child: Text(
                            '确定加入购物车',
                            style: TextStyle(color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _add_count() {
    setState(() {
      ++count;
    });
  }

  void _dix_count() {
    setState(() {
      --count;
    });
  }
}
