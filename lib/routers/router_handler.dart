import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:baixing/page/good_detail_page.dart';

Handler detailsHandler = Handler(
  handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return GoodDetailPage(goodsId: params['id'][0],);
  },
);
