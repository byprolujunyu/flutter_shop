import 'package:baixing/page/cart/cart_widget.dart';
import 'package:baixing/provider/cart_provide.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../service/service_method.dart';

import '../provider/counter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        centerTitle: true,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                showDialogC(context, '是否清空购物车', () {
                  Provide.value<CartProvide>(context).remove();
                  _getBackInfo(context);
                });
              })
        ],
      ),
//           floatingActionButton: Text('同步'),
//           floatingActionButtonLocation:FloatingActionButtonLocation.startTop ,
      body: FutureBuilder(
          future: _getBackInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: CartWidget(() {
                  _getBackInfo(context);
                }),
              );
            } else {
              return Center(child: Loading());
            }
          }),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return '完成加载';
  }
}
