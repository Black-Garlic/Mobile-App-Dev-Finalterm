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
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'main.dart';
import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

List<bool> checked = List.generate(3, (index) => false);
DateTime selectedDate = DateTime.now();

class AddPage extends StatefulWidget {
  const AddPage({
    Key? key,
  }) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<AddPage> {

  int id = 0;
  bool first = true;
  int time = 0;

  final ImagePicker _picker = ImagePicker();
  late XFile? _image;
  String _pickImageError = "";

  final _itemNameController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemDescController = TextEditingController();

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
        first = false;
      });

      //await firebase_storage.FirebaseStorage.instance.ref().putFile(_file);
    } catch (e) {
      setState(() {
        _pickImageError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
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
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Add'),
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

                time = DateTime.now().millisecondsSinceEpoch,
                if (!first) {
                  firebase_storage.FirebaseStorage.instance
                      .ref(_itemNameController.value.text + "_" + time.toString())
                      .putFile(File(_image!.path))
                      .then((p0) async =>
                      FirebaseFirestore.instance
                          .collection('product')
                          .add(<String, dynamic>{
                        'name': _itemNameController.value.text,
                        'price': int.parse(_itemPriceController.value.text),
                        'desc': _itemDescController.value.text,
                        'image': await firebase_storage.FirebaseStorage.instance
                            .ref(_itemNameController.value.text + "_" + time.toString())
                            .getDownloadURL(),
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'regDate': FieldValue.serverTimestamp(),
                        'modDate': FieldValue.serverTimestamp(),
                      }),
                  ),
                } else {
                  FirebaseFirestore.instance
                      .collection('product')
                      .add(<String, dynamic>{
                    'name': _itemNameController.value.text,
                    'price': int.parse(_itemPriceController.value.text),
                    'desc': _itemDescController.value.text,
                    'image': 'https://firebasestorage.googleapis.com/v0/b/mobile-app-final-2a3dd.appspot.com/o/default.png?alt=media&token=25379aa1-4c8d-40db-92d0-192a7723d755',
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'regDate': FieldValue.serverTimestamp(),
                    'modDate': FieldValue.serverTimestamp(),
                  }),
                },

                Navigator.pop(context),
              },
            ),
          ],
          centerTitle: true,
        ),
        body: ListView (
          children: <Widget>[
            Column(
              children: [
                first == true ?
                Image.network(
                  "http://handong.edu/site/handong/res/img/logo.png",
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                )
                :
                Image.file(
                  File(_image!.path),
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
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
              ],
            ),
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _itemNameController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Product Name',
                            ),
                          ),
                        const SizedBox(height: 12.0),
                        TextField(
                          controller: _itemPriceController,
                          decoration: const InputDecoration(
                          filled: true,
                          labelText: 'Price',
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        TextField(
                          controller: _itemDescController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Description',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}