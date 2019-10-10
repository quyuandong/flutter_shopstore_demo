
import 'package:flutter/material.dart';
import './Home.dart';
import './Category.dart';
import './Cart.dart';
import './User.dart';

import '../services/ScreenAdaper.dart';

class Tabs extends StatefulWidget {
  
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {

  List<Widget> _pageList = [
    HomePage(),
    CategoryPagePage(),
    CartPagePage(),
    UserPagePage()
  ];
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     this._pageController=new PageController(initialPage:this._currentIndex );
  }

  @override
  Widget build(BuildContext context) {
    Sad.init(context);
    return Scaffold(
      // appBar: AppBar(title: Text("shopStore"),),
      appBar: _currentIndex !=3 
      ? AppBar(
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak,size: 28,color: Colors.black87,),
          onPressed: null,
        ),
        title: InkWell(
          child: Container(
            height: Sad.h(68),
            decoration: BoxDecoration(
              color: Color.fromRGBO(2333, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.search),
                Text("笔记本",style: TextStyle(fontSize: Sad.size(28)),)

              ],
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, "/search");
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message,size: 28,color: Colors.black87,),
            onPressed: null,
          )
        ],

      )
      : AppBar(
        title: Text("用户中心"),
      ),
      body:PageView(
          controller: this._pageController,
          children: this._pageList,
          // },
        ),
      bottomNavigationBar:BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index){
          setState(() {
           this._currentIndex = index; 
           this._pageController.jumpToPage(index);
          });
        },
        type:BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("首页")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text("分类")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text("购物车")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("我的")
          ),
        ],
        
      ),
    );
  }
}