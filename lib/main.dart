import 'package:baixing/provider/cart_provide.dart';
import 'package:baixing/routers/application.dart';
import 'package:baixing/routers/routers.dart';
import 'package:flutter/material.dart';
import 'page/index_page.dart';
import 'package:provide/provide.dart';
import './provider/goods_info.dart';
import './provider/counter.dart';
import './provider/child_category.dart';
import './provider/category_goods_list.dart';
import 'package:fluro/fluro.dart';

void main() {
  var detailsInfoProvide = DetailsInfoProvide();
  var counter = Counter();
  var childcategory = ChildCategory();
  var providers = Providers();
  var categoryGoodsList = CategoryGoodsProvide();
  var cartProvide = CartProvide();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childcategory))
    ..provide(Provider<DetailsInfoProvide>.value(detailsInfoProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CategoryGoodsProvide>.value(categoryGoodsList));

  runApp(ProviderNode(
    child: MyApp(),
    providers: providers,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = new Router();
    Routers.configuerRouters(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: "百姓生活+",
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
