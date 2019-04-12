import 'package:baixing/page/cart/cart_widget.dart';
import 'package:baixing/provider/cart_provide.dart';
import 'package:baixing/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import '../provider/counter.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: _getBackInfo(context),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                child:
                    CartWidget(),
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
