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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'main.dart';
import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class DetailPage extends StatefulWidget {
  final int id;

  const DetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<DetailPage> {

  late int id;
  bool _edit = false;
  bool _newImage = false;
  int time = 0;

  final ImagePicker _picker = ImagePicker();
  late XFile? _image;
  String _pickImageError = "";

  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemDescController = TextEditingController();

  List _favoriteUser = [];
  bool _userContain = false;

  Future _getImage() async {
    try {
      print("set");
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      setState(() {
        print("setstate");
        _image = pickedFile;
        //_file = pickedFile as File;
        print("zxcvzxcv");
        _newImage = true;
      });

      //await firebase_storage.FirebaseStorage.instance.ref().putFile(_file);
    } catch (e) {
      setState(() {
        _pickImageError = e.toString();
      });
    }
  }

  Future<Text> getFavorite(ApplicationState appState) async {
    print('favorite');
    print(appState.item[id].id);

    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('favorite')
        .where('itemId', isEqualTo:appState.item[id].id)
        .get();
    _favoriteUser = _myDoc.docs;

    for (final document in _favoriteUser) {
      if (document.data()['uid'] == FirebaseAuth.instance.currentUser!.uid) {
        _userContain = true;
        break;
      }
    }

    var totalFavorite = _favoriteUser.length.toString();
    print(totalFavorite);

    return Text(
      totalFavorite,
      style: const TextStyle(
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    id = widget.id;

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Consumer<ApplicationState>(
        builder: (context, appState, _) => Scaffold(
          appBar:
            _edit == false ?
          AppBar(

            title: const Text('Detail'),
            centerTitle: true,
            actions: appState.item[id].uid == FirebaseAuth.instance.currentUser?.uid ?
              <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                  ),
                  onPressed: () => setState(() {
                    _edit = true;
                  }),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                  ),
                  onPressed: () async => {
                    FirebaseFirestore.instance
                        .collection('product')
                        .doc(appState.item[id].id)
                        .delete(),
                    Navigator.pushNamed(context, '/')
                  },
                ),
              ]
            :
              <Widget>[]
          )
            :
          AppBar(
            leading: TextButton(
              child: const Text(
                'Cancel',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              onPressed: () => setState(() {
                _edit = false;
              }),
            ),
            title: const Text('edit'),
            centerTitle: true,
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Save',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                onPressed: () async => {
                  print("zxcvzxdfxzvasd"),
                  time = DateTime.now().millisecondsSinceEpoch,

                  if (_newImage) {
                    firebase_storage.FirebaseStorage.instance
                        .ref(_itemNameController.value.text + "_" + time.toString())
                        .putFile(File(_image!.path))
                        .then((p0) async =>
                      FirebaseFirestore.instance
                          .collection('product')
                          .doc(appState.item[id].id)
                          .update({
                        'name': _itemNameController.value.text,
                        'price': int.parse(_itemPriceController.value.text),
                        'desc': _itemDescController.value.text,
                        'image': await firebase_storage.FirebaseStorage.instance
                          .ref(_itemNameController.value.text + "_" + time.toString())
                          .getDownloadURL(),
                        'modDate': FieldValue.serverTimestamp(),
                      }),
                    ),
                  } else {
                    FirebaseFirestore.instance
                        .collection('product')
                        .doc(appState.item[id].id)
                        .update({
                      'name': _itemNameController.value.text,
                      'price': int.parse(_itemPriceController.value.text),
                      'desc': _itemDescController.value.text,
                      'modDate': FieldValue.serverTimestamp(),
                    }),
                  },

                  setState(() {
                    _edit = false;
                  }),
                },
              ),
            ]
          ),
          body: ListView (
            children: <Widget>[
              _newImage == false ?
              Material(
                child: Image.network(
                  appState.item[id].image,
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              )
              :
              Material(
                child: Image.file(
                  File(_image!.path),
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
              _edit == false ?
              Row(
                children: const [
                  SizedBox(height: 60.0),
                ],
              )
              :
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt,
                      semanticLabel: 'filter',
                    ),
                    onPressed: _getImage,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _edit == false ?
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appState.item[id].name,
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.thumb_up_alt_sharp,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  final SnackBar snackBar;
                                  if (_userContain) {
                                    snackBar = const SnackBar(
                                      content: Text('You can only do it once!'),
                                    );
                                  } else {
                                    setState(() {
                                      _userContain = false;
                                    });
                                    FirebaseFirestore.instance
                                        .collection('favorite')
                                        .add(<String, dynamic>{
                                      'uid': FirebaseAuth.instance.currentUser!.uid,
                                      'itemId': appState.item[id].id,
                                    });

                                    snackBar = const SnackBar(
                                      content: Text('I LIKE IT'),
                                    );
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                },
                              ),
                              FutureBuilder<Text>(
                                future: getFavorite(appState),
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data;
                                  } else {
                                    return const Text(
                                      "0",
                                      style: TextStyle(
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }
                                }
                              ),

                            ],
                          )
                          :
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _itemNameController..text = appState.item[id].name,
                                  decoration: const InputDecoration(
                                    hintText: 'Product name',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your message to continue';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              _edit == false ?
                              Expanded(
                                child: Text(
                                  "\$ " + appState.item[id].price.toString(),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 20
                                  ),
                                )
                              )
                              :
                              Expanded(
                                child: TextFormField(
                                  controller: _itemPriceController..text = appState.item[id].price.toString(),
                                  decoration: const InputDecoration(
                                    hintText: 'Product price',
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 20
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your message to continue';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1.0,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child:
                _edit == false ?
                Text(
                  appState.item[id].desc,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                )
                :
                TextFormField(
                  controller: _itemDescController..text = appState.item[id].desc,
                  decoration: const InputDecoration(
                    hintText: 'Product price',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your message to continue';
                    }
                    return null;
                  },
                ),
              ),
              _edit == false ?
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Creator: " + appState.item[id].uid,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Created : " + appState.item[id].regDate.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Modified : " + appState.item[id].modDate.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              )
              :
              const Padding(padding: EdgeInsets.all(0),)
            ],
          )
        )
      ),
    );
  }
}
