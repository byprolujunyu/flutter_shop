import 'package:baixing/constants/index.dart';
import 'package:baixing/model/cart_info_model.dart';
import 'package:baixing/model/cart_new.dart';
import 'package:baixing/provider/cart_provide.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:scoped_model/scoped_model.dart';

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Provide<CartProvide>(builder: (context, child, val) {
      var cartInfo = val.cartDatas;
      var model = fromJson(cartInfo);
      print(cartInfo);
      if (cartInfo != null) {
        return model == null
            ? Container()
            : model.itemsCount == 0
                ? EmptyWidget()
                : ScopedModel<CartListModelNew>(
                    model: model,
                    child: Column(
                      children: <Widget>[
                        L(model),
                        CartBottomWidget(model),
                      ],
                    ),
                  );
      } else {
        return Container();
      }
    }));
  }

  CartListModelNew fromJson(List list) {
    List<CartItemModelNew> items = [];
    for (CartInfoModel json in list) {
      CartItemModelNew item = CartItemModelNew(
        price: json.price,
        count: json.count,
        imageUrl: json.images,
        productName: json.goodsName,
        isDeleted: false,
        isSelected: true,
        buyLimit: 99,
        id: json.goodsId,
      );
      items.add(item);
    }

    return CartListModelNew(items: items);
  }
}

class L extends StatelessWidget {
  CartListModelNew model;

  L(this.model);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartListModelNew>(
        builder: (context, child, model) {
      this.model = model;
      return Container(
        height: MediaQuery.of(context).size.height / 1.4,
        child: ListView.builder(
          itemExtent: 93,
          itemCount: model.itemsCount,
          itemBuilder: (context, index) {
            return item(context, model.items[index], index);
          },
        ),
      );
    });
  }

  CartItemModelNew data;

  Widget item(BuildContext context, CartItemModelNew item, int index) {
    this.data = item;
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: InkWell(
                  onTap: () => _switchChanged(index),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        item.isSelected
                            ? Icons.check_circle_outline
                            : Icons.radio_button_unchecked,
                        color: KColorConstant.themeColor,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Image.network(
                  item.imageUrl,
                  width: ScreenUtil().setWidth(120),
                  height: ScreenUtil().setWidth(200),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1, color: Colors.black12),
                    right: BorderSide(width: 1, color: Colors.black12),
                    left: BorderSide(width: 1, color: Colors.black12),
                    bottom: BorderSide(width: 1, color: Colors.black12),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil().setWidth(350),
                        margin: EdgeInsets.only(left: 5),
                        child: Text(item.productName),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => item.count > 1 && _downCount(index),
                          child: Container(
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setWidth(50),
                            decoration:
                                BoxDecoration(border: _getRemoveBtBorder()),
                            child: Icon(Icons.remove,
                                color: _getRemovebuttonColor()),
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setWidth(50),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: KColorConstant.cartItemCountTxtColor,
                                    width: 1)),
                            child: Text(
                              item.count.toString(),
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: KColorConstant.cartItemCountTxtColor),
                            )),
                        GestureDetector(
                          onTap: () =>
                              item.count < item.buyLimit && _addCount(index),
                          child: Container(
                            alignment: Alignment.center,
                            width: ScreenUtil().setWidth(50),
                            height: ScreenUtil().setWidth(50),
                            decoration:
                                BoxDecoration(border: _getAddBtBorder()),
                            child: Icon(Icons.add, color: _getAddbuttonColor()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 3),
              child: Column(

            children: <Widget>[
              Container(
                child: Text('¥ ${item.price}0'),
              )
            ],
          )),
        ],
      ),
    );
  }

  Color _getRemovebuttonColor() {
    return data.count > 1
        ? KColorConstant.cartItemChangenumBtColor
        : KColorConstant.cartDisableColor;
  }

  Border _getRemoveBtBorder() {
    return Border(
        bottom: BorderSide(width: 1, color: _getRemovebuttonColor()),
        top: BorderSide(width: 1, color: _getRemovebuttonColor()),
        left: BorderSide(width: 1, color: _getRemovebuttonColor()));
  }

  Border _getAddBtBorder() {
    return Border(
        bottom: BorderSide(width: 1, color: _getAddbuttonColor()),
        top: BorderSide(width: 1, color: _getAddbuttonColor()),
        right: BorderSide(width: 1, color: _getAddbuttonColor()));
  }

  _getAddbuttonColor() {
    return data.count >= data.buyLimit
        ? KColorConstant.cartDisableColor
        : KColorConstant.cartItemCountTxtColor;
  }

  _switchChanged(int i) {
    model.switchSelect(i);
  }

  _addCount(int i) {
    model.addCount(i);
  }

  _downCount(int i) {
    model.downCount(i);
  }
}

class EmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
          ),
          Container(
            width: ScreenUtil().setWidth(100),
            margin: EdgeInsets.all(10.0),
            height: ScreenUtil().setHeight(100),
            child: Image.network(
              'http://116.62.168.251:8090/empty_cart.png',
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: Text(
              '购物车还是空的,快去挑选商品吧',
            ),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(200),
            height: ScreenUtil().setHeight(50),
            color: Colors.red,
            child: InkWell(
              child: Text(
                '随便逛逛',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class CartBottomWidget extends StatelessWidget {
  final CartListModelNew model;

  CartBottomWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartListModelNew>(
        builder: (context, child, model) {
      // this.model = model;
      return Container(
        height: ScreenUtil().setWidth(100),

        decoration: BoxDecoration(
            color: KColorConstant.cartBottomBgColor,
            border: Border(
                top: BorderSide(
                    width: 1, color: KColorConstant.divideLineColor))),
        //    padding: EdgeInsets.only(left: ScreenUtil().setWidth(60)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: () => model.switchAllCheck(),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Icon(
                            model.isAllchecked
                                ? Icons.check_circle_outline
                                : Icons.radio_button_unchecked,
                            color: KColorConstant.themeColor,
                          ),
                        ),
                        Text(
                          KString.allSelectedTxt,
                          style: TextStyle(letterSpacing: 2),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: _TotalWidget(
                      totalPrice: model.sumTotal,
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 10),
                color: KColorConstant.goPayBtBgColor,
                width: ScreenUtil().setWidth(300),
                height: ScreenUtil().setWidth(100),
                child: Text(
                  '${KString.goPayTxt}(${model.totalCount})',
                  style: TextStyle(color: KColorConstant.goPayBtTxtColor),
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      );
    });
  }
}

class _TotalWidget extends StatefulWidget {
  final double totalPrice;

  _TotalWidget({Key key, this.totalPrice}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TotalWidgetState();
}

class _TotalWidgetState extends State<_TotalWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation animation;

  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = Tween(begin: 0, end: widget.totalPrice).animate(_controller);
    _controller.forward();
    _controller.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void didUpdateWidget(_TotalWidget oldWidget) {
    animation = Tween(begin: oldWidget.totalPrice, end: widget.totalPrice)
        .animate(_controller);
    _controller.forward(from: 0);

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: KString.totalSumTxt + ":  ",
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                    text: '￥${animation.value.toStringAsFixed(2)}',
                    style: KfontConstant.cartBottomTotalPriceStyle)
              ]),
        )
      ],
    );
  }
}
