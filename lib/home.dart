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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/detail.dart';
import 'package:shrine/model/item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'main.dart';
import 'model/products_repository.dart';
import 'model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String orderBy = "ASC";
  int index = -1;

  List<Card> _buildGridCards(BuildContext context, ApplicationState appState) {
    print("build grid");

    if (appState.item.isEmpty) {
      return const <Card>[];
    }

    print("length" + appState.item.length.toString());

    return appState.item.map((product) {
      int index = appState.item.indexOf(product);
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 17 / 12,
              child: Image.network(
                product.image,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 4.0),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "\$ " + product.price.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton (
              child: const Text(
                'more',
                textAlign: TextAlign.end,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: index,
                );
              },
            )
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/my page');
          },
        ),
        title: Consumer<ApplicationState>(
          builder: (context, appState, _) => Text(
          FirebaseAuth.instance.currentUser!.isAnonymous ?
          'Welcome Guest!'
          :
          'Welcome ' + appState.user.user!.displayName.toString() + '!'
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'filter',
            ),
            onPressed: () => setState(() {
              Navigator.pushNamed(context, '/add');
            }),
          ),
        ],
      ),
      body: ChangeNotifierProvider(
        create: (context) => DropDownProvider(),
        builder: (context, _) => Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding (
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 0),
                child: DropdownButton<String>(
                  value: orderBy,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      orderBy = newValue!;
                      if (orderBy == "ASC") {
                        print("Load Asc");
                        appState.sortProduct(true);
                      } else {
                        print("Load Desc");
                        appState.sortProduct(false);
                      }
                    });
                  },
                  items: <String>['ASC', 'DESC']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: OrientationBuilder(
                    builder: (context, orientation) {
                      return GridView.count(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                        padding: const EdgeInsets.all(16.0),
                        childAspectRatio: 8.0 / 12.0,
                        children: _buildGridCards(context, appState),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
