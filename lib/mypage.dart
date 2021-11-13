// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lottie/lottie.dart';

class MyPage extends StatefulWidget {
  const MyPage({
    Key? key,
  }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String _id = "";
  String _uid = "";
  String _email = "Anonymous";
  String _name = "Anonymous";
  String _statusMessage = "I promise to take the test honestly before GOD";

  final _statusMessageController = TextEditingController();
  bool _edit = false;

  Future<ListView> _getUserInfo() async {

    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (final document in _myDoc.docs) {
      _id = document.id;
      _uid = document['uid'] as String;
      _statusMessage = document['status_message'] as String;
      if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
        _email = document['email'] as String;
        _name = document['name'] as String;
      }
    }
    return ListView();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: const Text(
              'Back',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Profile'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.logout,
                semanticLabel: 'filter',
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
        body: Consumer<ApplicationState>(
          builder: (context, appState, _) => FutureBuilder<ListView>(
            future: _getUserInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView (
                  children: [
                    FirebaseAuth.instance.currentUser!.isAnonymous ?
                    Column(
                      children: [
                        Image.network(
                          "http://handong.edu/site/handong/res/img/logo.png",
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          _uid,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        const Text(
                          'Anonymous',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    )
                        :
                    Column(
                      children: [
                        Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL.toString(),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          _uid,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        Text(
                          _email,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 100,),
                    ListTile(
                      title: Text(
                        _name,
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    ListTile(
                      title: _edit == false ?
                      Text(
                        _statusMessage,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700
                        ),
                      )
                      :
                      TextFormField(
                        controller: _statusMessageController..text = _statusMessage,
                        decoration: const InputDecoration(
                          hintText: 'Status Message',
                        ),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your message to continue';
                          }
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      title: TextButton(
                        child: Text(
                          _edit == false ? 'Edit' : 'Save',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                        onPressed: () async => {
                          if (_edit == false) {
                            setState(() {
                              _edit = true;
                            })
                          } else {
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(_id)
                                .update({
                            'status_message': _statusMessageController.value.text,
                            }),
                            setState(() {
                              _edit = false;
                            })
                          },
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return ListView();
              }
            }
          )
        )
      ),
    );
  }
}
