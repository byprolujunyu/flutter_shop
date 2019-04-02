import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import '../provider/counter.dart';


class CartPage extends StatelessWidget {
  final Widget child;

  CartPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              Number(),
              MyButton()
            ],
          ),
        )
      )
    );
  }
}


class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20
      ),
      child: Provide<Counter>(
        builder: ( context, child, counter ){
          return Text("${ counter.value }");
        },
      ),
    );
  }
}


class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text("增加"),
        onPressed: (){
          Provide.value<Counter>(context).increment();
        },
      ),
    );
  }
}

