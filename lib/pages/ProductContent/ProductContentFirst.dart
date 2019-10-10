import 'package:flutter/material.dart';
import 'package:shopstore/config/Config.dart';
import 'package:shopstore/model/ProductContentModel.dart';
import 'package:shopstore/pages/services/ScreenAdaper.dart';
import 'package:shopstore/widget/JdButton.dart';
class ProductContentFirst extends StatefulWidget {

  final List _productContentList;
  ProductContentFirst(this._productContentList);

  @override
  _ProductContentFirstState createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst> {
  
  ProductContentitem _productContent;

  List _attr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._productContent = widget._productContentList[0];
    this._attr = this._productContent.attr;
    print(this._attr);

  }

  @override
  Widget build(BuildContext context) {
    //处理照片
    String pic = Config.domain + this._productContent.pic;
    pic = pic.replaceAll('\\', '/');
    
    return Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/12,
            child: Image.network("${pic}", fit: BoxFit.cover),
          ),

          //标题
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Text("${this._productContent.title}",
                style: TextStyle(
                    color: Colors.black87, fontSize: Sad.size(36))),
          ),

          //描述
          Container(
              padding: EdgeInsets.only(top: 10),
              child: Text("${this._productContent.subTitle}",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: Sad.size(28)))),
          //价格
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text("特价: "),
                      Text("¥${this._productContent.price}",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: Sad.size(46))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("原价: "),
                      Text("¥${this._productContent.oldPrice}",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: Sad.size(28),
                              decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                )
              ],
            ),
          ),

          //筛选
          Container(
            margin: EdgeInsets.only(top: 10),
            height: Sad.h(80),
            child: InkWell(
              onTap: () {
                _attrBottomSheet();
              },
              child: Row(
                children: <Widget>[
                  Text("已选: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("115，黑色，XL，1件")
                ],
              ),
            ),
          ),

          Divider(),

           Container(
            height: Sad.h(80),
            child: Row(
              children: <Widget>[
                Text("运费: ", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("免运费")
              ],
            ),
          ),
          Divider(),

        ],
      ),
    );
  }

  //颜色的具体项
  List<Widget> _getAttrItemWidget(arrtItem){
    List<Widget> attrItemList = [];
    arrtItem.list.forEach((item){
      attrItemList.add(Container(
        margin: EdgeInsets.all(10),
        child: Chip(
          label: Text("${item}"),
          padding: EdgeInsets.all(10),
        ),
      ));
    });
    return attrItemList;
  }

  //封装一个组件  渲染attr,弹出框商品的规格
  List<Widget> _getAttrWidget() {
    List<Widget> attrList = [];
    this._attr.forEach((attrItem){
      attrList.add(Wrap(
        children: <Widget>[
          Container(
            width: Sad.w(120),
            child: Padding(
              padding: EdgeInsets.only(top: Sad.h(22)),
              child: Text("${attrItem.cate}:" ,
                style: TextStyle(fontWeight: FontWeight.bold),),
            ),
          ),

          Container(
            width: Sad.gsw()-Sad.w(120),
            child: Wrap(
              children: _getAttrItemWidget(attrItem),
            ),
          )

        ],
      ));
    });
    return attrList;
  }

  //选择规格弹出框
  _attrBottomSheet(){
    showModalBottomSheet(
      context: context,
      builder: (contex) {
        return GestureDetector(
          //解决showModalBottomSheet点击消失的问题
          onTap: () {
            return false;
          },
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(Sad.w(20)),
                child: ListView(
                  children: <Widget>[
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getAttrWidget()
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                width: Sad.gsw(),
                height: Sad.h(156),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                        child: JdButton(
                          color: Color.fromRGBO(253, 1, 0, 0.9),
                          text: "加入购物车",
                          cb: () {
                            print('加入购物车');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: JdButton(
                            color: Color.fromRGBO(255, 165, 0, 0.9),
                            text: "立即购买",
                            cb: () {
                              print('立即购买');
                            },
                          )),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
  }
}