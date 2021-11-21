import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 18 ,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('설정', style: TextStyle(color: Colors.black, fontSize: 14),),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _listTile("공지사항", Icons.announcement_rounded),
          _listTile("알림", Icons.alarm_rounded),
          _listTile("앱 버전", Icons.announcement_outlined),
          Divider(height: 1,),
          _listTile("문의/도움말", Icons.email),
          Divider(height: 1,),
          _listTile("이용약관", Icons.list_rounded),
          _listTile("개인정보처리방침", Icons.list_rounded),
        ],
      ),
    );
  }

  Widget _listTile(context, icon) {
    return ListTile(
      tileColor: Colors.white,
      contentPadding: EdgeInsets.only(left: 30, right: 30),
      title: Text(context, style: TextStyle(fontSize: 14),),
      leading: Icon(icon),
    );
  }
}
