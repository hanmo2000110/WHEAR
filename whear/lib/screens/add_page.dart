import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whear/auth/auth_middleware.dart';
import 'package:whear/binding/binding.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('add_page'),
    );
  }
}
