import 'package:flutter_screenutil/flutter_screenutil.dart';

//移动端适配问题，适配不同的高度

class Sad{

  //c初始化设备的规格
  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 1080,height: 1920)..init(context);
  }

  //设置高度
  static h(double value){
    return ScreenUtil.getInstance().setHeight(value);
  }

  //设置宽度
  static w(double value){
    return ScreenUtil.getInstance().setWidth(value);
  }
  
  //获取设备的宽度
  static gsw(){
    return ScreenUtil.screenWidthDp;
  }

  //获取设备的高度
  static gsh(){
    return ScreenUtil.screenHeightDp;
  }

  static gsph(){
    return ScreenUtil.screenHeight;
  }
  static gspw(){
    return ScreenUtil.screenWidth;
  }

  static size(double value){
   return ScreenUtil.getInstance().setSp(value);  
  }
}