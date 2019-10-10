import 'package:flutter/material.dart';

class ProductContentThird extends StatefulWidget {
  @override
  _ProductContentThirdState createState() => _ProductContentThirdState();
}

class _ProductContentThirdState extends State<ProductContentThird> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context,index){
          return ListTile(
            title: Text("第${index}条"),
          );
        },
      ),
    );
  }
}