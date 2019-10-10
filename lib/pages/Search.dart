import 'package:flutter/material.dart';
import 'package:shopstore/pages/services/ScreenAdaper.dart';
import 'package:shopstore/pages/services/SearchServices.dart';
import 'package:flutter/rendering.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _keywords;
  List _historyListData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //获取历史数据
    this._getHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: TextField(
            autocorrect: true,
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
            color: Color.fromRGBO(233, 233, 233, 0.8),
            borderRadius: BorderRadius.circular(30),
            
          ),
        ),
        actions: <Widget>[
          InkWell(
            child: Container(
              height: Sad.h(68),
              width: Sad.w(140),
              child: Row(
                children: <Widget>[Text("搜索")],
              ),
            ),
            onTap: (){
               SearchServices.setHistoryData(this._keywords);
              Navigator.pushReplacementNamed(context, "/productList",arguments: {"keywords":this._keywords});
            },
          )
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text("热搜",style: Theme.of(context).textTheme.title,),
            ),
            Divider(),
            Wrap(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 0.9),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text("女装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("笔记本电脑"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装111"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装"),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(233, 233, 233, 0.9),
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("女装"),
                )
              ],
            ),
            SizedBox(height: 10),

            //历史记录
            _historyListWidget(),
            
            
              

          ],
        ),
      ),
    );
  }

  //===============================
  //数据
  _getHistoryData() async {
    var _historyListData = await SearchServices.getHistoryList();
    setState(() {
     this._historyListData = _historyListData; 
    });
  }



  //===============================
  //组件

  //删除的弹出框
  _showAlertDialog(keywords) async {
    var result = await showDialog(
      //表示点击灰色背景的时候是否消失弹出框
      barrierDismissible : false,
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("提示信息"),
          content: Text("你确定要删除吗？"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: (){
                Navigator.pop(context,"Cancle");
              },
            ),
            FlatButton(
              child: Text("确定"),
              onPressed: () async{            
                //注意异步      
                await SearchServices.removeHistoryData(keywords);
                this._getHistoryData();
                Navigator.pop(context,"Ok");
              },
            )
          ],
        );
      }
    );
  }

  //历史组件
  _historyListWidget(){
    if(_historyListData.length > 0){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text("历史记录", style: Theme.of(context).textTheme.title),
          ),
          Divider(),
          Column(
            children: this._historyListData.map((value){
              return Column(
                children: <Widget>[
                  ListTile(
                    title: Text("${value}"),
                    onLongPress: (){
                      this._showAlertDialog("${value}");
                    },
                  ),
                  Divider(),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 100),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: (){
                  SearchServices.clearHistoryList();
                  this._getHistoryData();
                },
                child: Container(
                  width: Sad.w(400),
                  height: Sad.h(84),
                  
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45, width: 1),
                      
                      ),
                      
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.delete), Text("清空历史记录")],
                  ),
                ),
              )
            ],
          )


        ],
      );
    }else{
      return Text("");
    }
  }
}