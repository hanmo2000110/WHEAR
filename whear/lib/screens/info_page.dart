import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';


class Info{
  var kind;
  var title;
  var content;

  Info(
      this.kind,
      this.title,
      this.content,
      );
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int count = 1;
  List<Info> _infoDataList = [Info('2021-11-22', 'WHEAR 앱 출시', '앱이 출시되었습니다 !')];

  var scrollController = ScrollController().obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 15),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "공지사항",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
      body: Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
            child: ListView.separated(
                controller: scrollController.value,
                itemBuilder: (BuildContext _context, index){
                  return Container(
                    child: _makeInfoTile(
                      "${_infoDataList[index].kind}",
                      "${_infoDataList[index].title}",
                      "${_infoDataList[index].content}",
                    ),
                  );
                },
                separatorBuilder: (_, index) => Divider(),
                itemCount: count),
          )
      )
    );
  }

  Widget _makeInfoTile(sub, title, content) {
    return Container(
      child : ExpansionTile(
        subtitle: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        title: new Text(
          sub,
          style: TextStyle(
            fontFamily: "Barun",
            fontSize: 14,
          ),
        ),
        initiallyExpanded: false,
        backgroundColor: Colors.white,
        children: <Widget>[
          Divider(height: 1),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: "Barun",
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
