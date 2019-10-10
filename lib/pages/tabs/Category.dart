import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shopstore/model/CateModel.dart';
//屏幕分辨率适配
import '../services/ScreenAdaper.dart';
//api请求地址
import '../../config/Config.dart';



class CategoryPagePage extends StatefulWidget {
  @override
  _CategoryPagePageState createState() => _CategoryPagePageState();
}

class _CategoryPagePageState extends State<CategoryPagePage>  with AutomaticKeepAliveClientMixin  {
  
  //定义数据
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

    @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLeftCateData();
  }

  
  @override
  Widget build(BuildContext context) {
    //初始化屏幕的尺寸
    Sad.init(context);

    //计算右侧GridView宽高比

    //计算左侧宽度
    var leftWidth = Sad.gsw() / 4;

    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth = (Sad.gsw()-leftWidth-20-20) / 3;

    //获取计算后的宽度
    rightItemWidth = Sad.w(rightItemWidth);

    //获取计算后的高度
    var rightItemHeight = rightItemWidth + Sad.h(28);


    return Row(
     children: <Widget>[

       //左侧导航数据
       _leftCateWidget(leftWidth),

      //右侧数据
      _rightCateWidget(rightItemWidth, rightItemHeight),
       
     ],
    );
  }
  //=======================================
  //获取左侧的分类的数据
  _getLeftCateData() async {
    var api = "${Config.domain}api/pcate";
    var result = await Dio().get(api);
    var leftCateList = new CateModel.fromJson(result.data);
    setState(() {
     this._leftCateList = leftCateList.result;
    });
    this._getRightCateData(leftCateList.result[0].sId);
  }

  //获取右侧的分类的数据
 _getRightCateData(pid) async{
      var api = '${Config.domain}api/pcate?pid=${pid}';
      var result = await Dio().get(api);
      var rightCateList = new CateModel.fromJson(result.data);
      // print(rightCateList.result);
      setState(() {
        this._rightCateList = rightCateList.result;
      });
  }

  //=======================================
  //左侧分类组件
  Widget _leftCateWidget(leftWidth){
    if(this._leftCateList.length > 0){
      return Container(
         width: leftWidth,
         height: double.infinity,
         child: ListView.builder(
           itemCount: this._leftCateList.length,
           itemBuilder: (context,index){
             return Column(
               children: <Widget>[
                 InkWell( //设置可以点击
                   //点击事件
                   onTap: (){
                     setState(() {
                      this._selectIndex = index; 
                      this._getRightCateData(this._leftCateList[index].sId);
                     });
                   },


                  child: Container(
                    width: double.infinity,
                    height: Sad.h(114),
                    padding: EdgeInsets.only(top:Sad.h(34)),
                    child: Text("${this._leftCateList[index].title}",textAlign: TextAlign.center),
                            color: _selectIndex==index? Color.fromRGBO(240, 246, 246, 0.9):Colors.white,
                  ),
                 ),
                 Divider(height: 2,), //分割线
               ],
             );
           },
         ),
       );
    }else{
      return Container(         
            width: leftWidth,
            height: double.infinity
         );
    }
  }

  //右侧分类组件
  Widget _rightCateWidget(rightItemWidth,rightItemHeight){
    if(this._rightCateList.length>0){
      return Expanded(
         flex: 1,
         child: Container(
           padding: EdgeInsets.all(10),
           height: double.infinity,
           color: Color.fromRGBO(240, 246, 246, 0.9),
           child: GridView.builder(
             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 3,
               childAspectRatio: rightItemWidth / rightItemHeight,
               crossAxisSpacing: 10,
               mainAxisSpacing: 10
             ),
             itemCount: this._rightCateList.length,
             itemBuilder: (context,index){
               //处理图片
               String pic=this._rightCateList[index].pic;
               pic=Config.domain+pic.replaceAll('\\', '/');

               return InkWell(
                
                onTap: (){
                  Navigator.pushNamed(context, "/productList",arguments: {
                    "cid" : this._rightCateList[index].sId
                  });
                },

                 child: Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network("${pic}",fit: BoxFit.cover),
                      ),
                      Container(
                        height: Sad.h(48),
                        child: Text("${this._rightCateList[index].title}"),
                      )
                    ],
                  ),
                ),
               );
             }

           ),
         ),
       );
    }else{
      return Expanded(
        flex: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("加载中..."),
        )
      );
    }
  }
}
