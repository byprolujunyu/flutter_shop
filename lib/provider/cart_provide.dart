import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_info_model.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartInfoModel> cartDatas = [];

 static final String cartKey = 'cartInfo';

  save(goodsId, goodsName, count, price, images) async {
    //初始化SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString(cartKey); //获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; //默认为没有
    int ival = 0; //用于进行循环的索引使用
    tempList.forEach((item) {
      //进行循环，找出是否已经存在该商品
      //如果存在，数量进行+1操作

      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] += count;
        try {
          cartDatas[ival].count += count;
        } catch (e) {
          print(e);
        }
        isHave = true;
      }

      ival++;
    });
    //  如果没有，进行增加
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images
      };
      tempList.add(newGoods);
      cartDatas.add(CartInfoModel.fromJson(newGoods));
    }
    //把字符串进行encode操作，
    cartString = json.encode(tempList).toString();
    print('字符串>>>>>>>>>>>>>>>$cartString');
    print('数据模型>>>>>>>>>>>>>>>${cartDatas}');
    prefs.setString(cartKey, cartString); //进行持久化
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();//清空键值对
    prefs.remove(cartKey);
    cartDatas.clear();
    print('清空完成-----------------');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartDatas.clear();
    cartString = prefs.getString(cartKey); //获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    tempList.forEach((item) {
      cartDatas.add(CartInfoModel.fromJson(item));
    });
    notifyListeners();
  }
}
