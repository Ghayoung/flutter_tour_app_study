import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tour_app_practice/data/user.dart';

class SignPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignPage();
}

class _SignPage extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = '';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckController;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckController = TextEditingController();

    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database?.reference().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _idTextController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '4자 이상 입력해주세요',
                    labelText: '아이디',
                    border: OutlineInputBorder()
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }
}