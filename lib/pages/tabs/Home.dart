import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../services/ScreenAdaper.dart';
import 'package:dio/dio.dart';

//轮播图类模型
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
//数据请求路径
import '../../config/Config.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {

  //定义的数据
  List _focusData=[];//轮播图
  List _hotProductList = [];  //猜你喜欢
  List _bestProductList = []; //热门推荐

    @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();

  }

  @override
  Widget build(BuildContext context) {
    //初始化屏幕的尺寸
    Sad.init(context);

    return ListView(
      
        children: <Widget>[
          //搜索组件
          // _searchWidget(),
          
          //轮播图组件
            _swiperWidget(),

            //猜你喜欢
            SizedBox(height: Sad.h(20)),
            _titleWidget("猜你喜欢"),
            SizedBox(height: Sad.h(20)),
            _hostProductListWidget(),
            
            //热门推荐
            SizedBox(height: Sad.h(20)),
            _titleWidget("热门推荐"),
            SizedBox(height: Sad.h(20)),
            _recProductItemWidget(),

        ],
    );
  }
  //============================================
    //获取轮播图 模拟model
  _getFocusData() async {
    var url = "${Config.domain}api/focus";
    var result = await Dio().get(url);
    
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
        this._focusData= focusList.result;
    });
  }

  //获取猜你喜欢的数据
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result; 
    });
    
  }

  //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result; 
    });
  }
  
  
  //============================================
  //搜索组件
  Widget _searchWidget(){
    return RaisedButton(
      child: Text("跳转到搜索组件"),
      onPressed: (){
        Navigator.pushNamed(context, "/search");
      },
    );
  }

  //轮播图组件
  Widget _swiperWidget(){
    //图片列表
    if(this._focusData.length > 0){
      return Container(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Swiper(
          itemCount: this._focusData.length,
          pagination: new SwiperPagination(),
          autoplay: true, //自动播放
          control: new SwiperControl(),

          itemBuilder: (BuildContext context, int index){
            String pic=this._focusData[index].pic;
            return new Image.network(
              "http://jd.itying.com/${pic.replaceAll('\\', '/')}",
                 
                fit: BoxFit.fill,
            );
          },)
        ),
      );
    }else{
      return Text('加载中...');
    }
  }

  // 猜你喜欢，热门推荐标题文本
  Widget _titleWidget(value){
    
    Sad.init(context);  //初始化适配器

    return Container(
      height: Sad.h(50),
      
      margin: EdgeInsets.only(left: Sad.w(20),top: Sad.h(20)),
      padding: EdgeInsets.only(left: Sad.w(20)),

      //设置盒子的 背景装饰
      decoration: BoxDecoration(
        border: Border(
         left: BorderSide(
           color: Colors.red,
           width: Sad.w(10)
         )
        )
      ),
      child: Text(value,style: TextStyle(
        color: Colors.black54
      ),),
    );
  }

  //猜你喜欢
  Widget _hostProductListWidget(){
    if(this._hotProductList.length > 0){
      return Container(
      height: Sad.h(244),
      padding: EdgeInsets.all(Sad.w(20)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: this._hotProductList.length,
        itemBuilder: (context,index){
          String sPic = this._hotProductList[index].sPic;
          sPic = Config.domain + sPic.replaceAll("\\", "/");
          return Column(
            children: <Widget>[
              Container(
                height: Sad.h(140),
                width: Sad.w(140),
                margin: EdgeInsets.only(right: Sad.h(21)),
                child: Image.network(sPic,fit: BoxFit.cover),
              ),

              Container(
                padding: EdgeInsets.only(top: Sad.h(10)),
                height: Sad.h(60),
                child: Text(
                  "¥${this._hotProductList[index].price}",
                    style: TextStyle(color: Colors.red),
                ),
              )
            ],
          );
        },
      ),
    );
    }else{
      return Text("");
    }
  }
  
  //热门推荐
  Widget _recProductItemWidget() {
    //获取到每一个Container的大小
    var itemWidth = (Sad.gsw()-30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
       children: this._bestProductList.map((value) {
          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll("\\", "/");
          return InkWell(
            onTap: (){
              Navigator.pushNamed(context, '/productContent',arguments: {
                "id":value.sId
              });
            },

            child: Container(
              padding: EdgeInsets.all(10),
              width: itemWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(233, 233, 233, .9),
                  width: 1
                )
              ),
              child:  Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: AspectRatio( //设置盒子的宽高比
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        "${sPic}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top:Sad.h(20)),
                    child: Text(
                      "${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: Sad.h(20)),
                    child: Stack( //实现定位操作
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "¥${value.price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("¥${value.oldPrice}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough)),
                        )

                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList()
      ),
      
    );
  }

}
