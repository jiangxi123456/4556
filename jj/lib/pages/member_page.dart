import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';
class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('个人中心')),
      body: Container(
        child: Provide<Counter>(builder: (context,child,counter){
          return Text('${counter.value}');
        }),
      ),
    );
  }
}