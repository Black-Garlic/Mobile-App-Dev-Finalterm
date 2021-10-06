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
import 'package:lottie/lottie.dart';

class MyPage extends StatelessWidget {
  const MyPage({
    Key? key,
  }) : super(key: key);

  List<Card> _hotelList(BuildContext context) {
    List<Product> products = ProductsRepository().loadFavoriteProducts();

    return products.map((product) {
      return Card (
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/detail',
                    arguments: Product(
                      id: product.id,
                      isFeatured: product.isFeatured,
                      star: product.star,
                      name: product.name,
                      address: product.address,
                      phone: product.phone,
                      desc: product.desc,
                    ),
                  );
                },
                child: Image.asset(
                  product.assetName,
                  width: 600,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 15,
              child: Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )
              )
            ),
            Positioned(
                bottom: 15,
                left: 15,
                child: Text(
                    product.address,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    )
                )
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite'),
        ),
        body: ListView (
          children: [
            Column(
              children: [
                ClipOval(
                  clipper: MyClipper(),
                  child: Lottie.asset('assets/stay-safe-stay-home.json'),
                ),
                const Text(
                  'Yoon Ha Neul',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700
                  ),
                ),
                const Text(
                  '21500453',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ],
            ),
            const ListTile(
              title: Text(
                'My Favorite Hotel List',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700
                ),
              ),
            ),
            Column(
              children: _hotelList(context),
            )
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect>{

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(82, 82, size.width - 164, size.height - 164);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
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

    return Expanded(
      child:ListView.builder(
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
      )
    );
  }
}