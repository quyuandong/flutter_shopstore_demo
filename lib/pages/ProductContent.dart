import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopstore/config/Config.dart';
import 'package:shopstore/model/ProductContentModel.dart';
import 'package:shopstore/pages/services/ScreenAdaper.dart';
import 'package:flutter/widgets.dart';
import 'package:shopstore/widget/JdButton.dart';
import 'package:shopstore/widget/LoadingWidget.dart';

import 'ProductContent/ProductContentFirst.dart';
import 'ProductContent/ProductContentSecond.dart';
import 'ProductContent/ProductContentThird.dart';

class ProductContentPage extends StatefulWidget {

  final Map arguments;
  ProductContentPage({Key key,this.arguments}) : super(key:key);

  @override
  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage> {

  List _productContentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContentData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: Sad.w(400),
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(child: Text("商品"),),
                    Tab(child: Text("详情"),),
                    Tab(child: Text("评价"),),
                  ],
                ),
              )
            ],
          ),

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: (){
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(Sad.w(600), 76, 10, 0),
                  items: [
                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.home),
                          Text("首页")
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.search),
                          Text("搜索")
                        ],
                      ),
                    )
                  ]
                
                );},

            )
          ],
        ),

        body: this._productContentList.length > 0
        ? Stack(
          children: <Widget>[
            TabBarView(
              children: <Widget>[
                 ProductContentFirst(this._productContentList),
                 ProductContentSecond(this._productContentList),
                  ProductContentThird()
              ],
            ),

            Positioned(
              width: Sad.gsw(),
              height: Sad.h(180),
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.black26,
                      width: 1
                    )
                  ),
                  color: Colors.white
                ),

                child: Row(
                  
                  children: <Widget>[
                    
                    Container(
                      padding: EdgeInsets.only(top: Sad.h(10)),
                      width: 100,
                      height: Sad.h(140),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Text("购物车")
                        ],
                      ),
                    ),
                    Expanded(
                      
                      flex: 1,
                      child: JdButton(
                        color:Color.fromRGBO(253, 1, 0, 0.9),
                        text: "加入购物车",
                        cb: (){
                          print('加入购物车');
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: JdButton(
                        color: Color.fromRGBO(255, 165, 0, 0.9),
                        text: "立即购买",
                        cb: (){
                          print('立即购买');
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
        : LoadingWidget(),
      )
    );
  }

  //==================================
  //数据模块
  //获取商品的数据
  _getContentData() async {
    var api = "${Config.domain}api/pcontent?id=${widget.arguments['id']}";
    var result = await Dio().get(api);
    var productContent = new ProductContentModel.fromJson(result.data);
    setState(() {
      this._productContentList.add(productContent.result) ;
    });
  }
  //==================================
}