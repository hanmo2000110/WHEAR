import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';

import '/screens/setting_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int post = 0;
  int follower = 0;
  int following = 0;

  List<Card> _buildGridCards(BuildContext context) {
    // if (products.isEmpty) {
    //   return const <Card>[];
    // }

    List products = [
      'https://file2.nocutnews.co.kr/newsroom/image/2021/06/10/202106102251357359_0.jpg',
      'https://www.artinsight.co.kr/data/tmp/2106/20210603224823_vsmohzcf.jpg',
      'https://i.ytimg.com/vi/NbGi0egSPak/maxresdefault.jpg',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxMQNYmpTHGRFThQoWXajOrIanmwqtDMgQSA&usqp=CAU'
    ];

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Image.network(
              product,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 30,
                height: 30,
                child: Icon(Icons.cloud, color: Colors.blue,),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ]
        )
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필', style: TextStyle(color: Colors.black, fontSize: 14),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black,),
            onPressed: () {
              Get.to(SettingPage());
            },
          ),
          TextButton(
            child: Text('Edit'),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 20.0),
              child: CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.lightBlueAccent,
                backgroundImage: NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text('${post}', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text('게시물', style: TextStyle(letterSpacing: 1.0),),
                  ],
                ),
                Column(
                  children: [
                    Text('${follower}', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text('팔로워', style: TextStyle(letterSpacing: 1.0),),
                  ],
                ),
                Column(
                  children: [
                    Text('${following}', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text('팔로잉', style: TextStyle(letterSpacing: 1.0),),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15,),
            Divider(height: 1,),
            GridView.count(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 9.0/9.0,
              children: _buildGridCards(context),
            )
          ],
        ),
      )
    );
  }
}
