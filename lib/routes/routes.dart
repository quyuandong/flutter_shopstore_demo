import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/Search.dart';
import '../pages/ProductList.dart';
import '../pages/ProductContent.dart';


//路由规则
final routes = {
  "/":(context) => Tabs(),
  "/search":(context) => SearchPage(),
  "/productList":(context,{arguments}) => ProductListPage(arguments:arguments),
  "/productContent":(context,{arguments}) => ProductContentPage(arguments:arguments),
};


// 如果你要把路由抽离出去，需要写下面这一堆的代码
// 抽离所写的路由规则
var onGenerateRoute=(RouteSettings settings) {
      // 统一处理
      final String name = settings.name; 
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
            final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
            return route;
        }
      }
};