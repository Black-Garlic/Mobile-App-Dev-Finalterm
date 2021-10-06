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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite'),
        ),
        body: FavoriteList(),
      ),
    );
  }
}

class FavoriteList extends StatefulWidget {
  const FavoriteList({
    Key? key,
  }) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoriteList> {
  @override
  Widget build(BuildContext context) {
    List<Product> products = ProductsRepository().loadFavoriteProducts();

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(products[index].id.toString()),
          onDismissed: (direction) {
            setState(() {
              ProductsRepository().changeProduct(products[index].id, false);
              products.removeAt(index);
            });
          },
          background: Container (color: Colors.red),
          child: ListTile(
            title: Text(products[index].name),
          ),
        );
      }
    );
  }
}