
import 'package:flutter/material.dart';
import 'package:shopstore/model/ProductModel.dart';
import 'package:shopstore/widget/LoadingWidget.dart';
import "./services/ScreenAdaper.dart";
import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../model/ProductModel.dart';

class ProductListPage extends StatefulWidget {

  Map arguments;
  ProductListPage({Key key, this.arguments}) : super(key: key);
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  //Scaffold key
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  //用于上拉分页
  ScrollController _scrollController = ScrollController();

  //分页
  int _page = 1;

  //每页多少条数据
  int _pageSize = 8;

  //数据
  List _productList = [];

  /*
  排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  */
  String _sort = "";

  //解决重复请求的问题
  bool flag = true;

  //是否有数据
  bool _hasMore = true;

  //判断是否有搜索数据
  bool _hasData = true;

  //二级导航数据
  List _subHeaderList = [
    {"id": 1, "title":"综合", "fileds":"all", "sort":-1,},
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];

  //二级导航选中判断
  int _selectHeaderId = 1;

  //配置search 搜索框的值
  var _initKeywordsController = new TextEditingController();

  var _cid ;      //商品列表的id
  var _keywords;  //搜索的关键字

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._cid = widget.arguments["cid"];
    this._keywords = widget.arguments["keywords"];
    this._initKeywordsController.text = this._keywords;
  

    //获取商品列表
    _getProductListData();

    //监听滚动条滚动事件
    _scrollController.addListener((){
      if(_scrollController.position.pixels > _scrollController.position.maxScrollExtent -20){
       if (this.flag && this._hasMore) {
          _getProductListData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //初始化屏幕的分辨率
    Sad.init(context);

    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
          title: Container(
            child: TextField(
              controller: this._initKeywordsController,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none
                )
              ),
              onChanged: (value){
                setState(() {
                 this._keywords = value; 
                });
              },
            ),
            height: Sad.h(68),
            decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.9),
              borderRadius: BorderRadius.circular(30)
            ),
          ),
          actions: <Widget>[
            InkWell(
              child: Container(
                height: Sad.h(68),
                width: Sad.w(120),
                child: Row(
                  children: <Widget>[Text("搜索")],
                ),
              ),
              onTap: () {
                 this._subHeaderChange(1);
              },
            )
          ],
        ),

      endDrawer: Drawer(
        child: Container(
          child: Text("实现筛选功能"),
        ),
    ),

      body: this._hasData 
        ? Stack(
            children: <Widget>[
              _ProductListWidget(),
              _subHeaderWidget(),
            ],
          )
        : Center(
            child: Text("没有您要浏览的数据")
          )   
    );
  }

  //==========================================
  //获取当前数据
  //获取商品列表数据
  _getProductListData() async {
    setState(() {
     this.flag = false; 
    });


    var api ;
    if(this._keywords==null){
      api ='${Config.domain}api/plist?cid=${this._cid}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }else{     
      api ='${Config.domain}api/plist?search=${this._keywords}&page=${this._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    }
    var result = await Dio().get(api);
    var productList = new ProductModel.fromJson(result.data);

    //判断是否有搜索数据
    if(productList.result.length==0 && this._page==1){
      setState(() {
        this._hasData=false; 
      });
    }else{
        this._hasData=true; 
    }

    //判断最后一页有没有数据
    if(productList.result.length<this._pageSize){
      setState(() {
       this._productList.addAll(productList.result);
       this._hasMore = false;
       this.flag = true; 
      });
    }else{
      setState(() {
        this._productList.addAll(productList.result);
        this._page ++;
        this.flag = true;
      });
    }
    
  }

 
  //==========================================
  //布局组件
   //显示加载中的圆圈
  Widget _showMore(index){
    if(this._hasMore){
      return (index == this._productList.length-1) ? LoadingWidget() : Text("");
    }else{
      return (index==this._productList.length-1)?Text("--我是有底线的--"):Text("");
    }
  }

  //获取商品列表
  Widget _ProductListWidget(){
    if(this._productList.length > 0){
        return Container(
        padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: Sad.h(80)),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: this._productList.length,
          itemBuilder: (context,index){

            //处理图片
            String pic = this._productList[index].pic;
            pic = Config.domain + pic.replaceAll("\\", "/");

            //每一个元素
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: Sad.w(180),
                      height: Sad.h(180),
                      child: Image.network(
                          "${pic}",
                          fit: BoxFit.cover),
                    ),
                    
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: Sad.h(220),
                        margin: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${this._productList[index].title}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            
                            Row(
                              children: <Widget>[
                                Container(
                                  height: Sad.h(40),
                                  margin: EdgeInsets.only(right: 10,top: 4),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

                                  //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child: Text("4G"),
                                ),

                                Container(
                                  height: Sad.h(40),
                                  margin: EdgeInsets.only(right: 10,top: 4),
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromRGBO(230, 230, 230, 0.9),
                                  ),
                                  child: Text("126"),
                                )
                              ],
                            ),

                            Text(
                              "¥${this._productList[index].price}",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 16),
                            )

                          ],
                        ),
                      ),
                    ),

                  ],
                    
                ),
                Divider(height: 20),
                _showMore(index)
              ],
            );
          },
        )
      );
    }else{
      //加载中
      return LoadingWidget();
    }
  }

  //导航改变的时候触发
  _subHeaderChange(id){
    if(id == 4){
      _scaffoldKey.currentState.openEndDrawer();
      setState(() {
       this._selectHeaderId = id; 
      });
    }else{
      setState(() {
       this._selectHeaderId = id;
       this._sort = "${this._subHeaderList[id-1]['fileds']}_${this._subHeaderList[id - 1]["sort"]}"; 
      
        //重置分页
        this._page = 1;
        //重置数据
        this._productList = [];
        //改变sort排序
        this._subHeaderList[id-1]['sort'] = this._subHeaderList[id - 1]['sort'] * -1;
        //回到顶部
        _scrollController.jumpTo(0);
        //重置_hasMore 
        this._hasMore = true;
        //重新请求数据
        this._getProductListData();

      });
    }
  }

  //显示Header Icon
  Widget _showIcon(id){
    if(id==2 || id==3){
      if(this._subHeaderList[id-1]['sort']==1){
        return Icon(Icons.arrow_drop_down);
      }
      return Icon(Icons.arrow_drop_up);
    }
    return Text("");
  }


  //筛选导航
  Widget _subHeaderWidget(){
    return Positioned(
      top: 0,
      height: Sad.h(100),
      width: Sad.gsw(),
      child: Container(
        height: Sad.h(100),
        width: Sad.gsw(),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color.fromRGBO(233, 233, 233, 0.9)
            )
          ),
        ),
        child: Row(
          children: this._subHeaderList.map((value){
            return Expanded(
              flex: 1,
              child: InkWell(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, Sad.h(16), 0, Sad.h(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${value["title"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: (this._selectHeaderId == value["id"])
                                ? Colors.red
                                : Colors.black54),                        
                      ),
                      _showIcon(value["id"])
                    ],
                  )
                ),
                onTap: (){
                  _subHeaderChange(value["id"]);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  
}