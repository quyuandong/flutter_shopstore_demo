import 'dart:convert';

import './Storage.dart';

class SearchServices {
  
  //设置本地历史搜索中的数据
  static setHistoryData(keywords) async {
    try {
      List serachListData = json.decode(await Storage.getString("searchList"));
      //判断本地是否保存的有数据
      var hasData  = serachListData.any((v){
        return v == keywords;
      });

      if(!hasData){
        serachListData.add(keywords);
        await Storage.setString("searchList", json.encode(serachListData));
      }

    } catch (e) { //当前没有searchList该项
      List tempList  = new List();
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  //获取到本地的历史数据
  static getHistoryList() async {
    try {
      List searchListData = json.decode( await Storage.getString("searchList"));
      return searchListData ;
    } catch (e) {
      return [];
    }
  }

  //移除指定项
  static removeHistoryData(keywords) async {
    List searchListData = json.decode(await Storage.getString("searchList"));
    searchListData.remove(keywords);
    await Storage.setString("searchList", json.encode(searchListData));
  }

  //删除所有的
  static clearHistoryList() async {
    await Storage.remove("searchList");
  }
}