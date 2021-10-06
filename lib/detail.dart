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

class DetailPage extends StatelessWidget {
  final int id;
  const DetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Product product = ProductsRepository().loadProduct(id);

    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(product.star >= 1 ? Icons.star: Icons.star_border, color: Colors.yellow),
                      Icon(product.star >= 2 ? Icons.star: Icons.star_border, color: Colors.yellow),
                      Icon(product.star >= 3 ? Icons.star: Icons.star_border, color: Colors.yellow),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TitleWidget(name: product.name),
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      product.address,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    Text(
                      product.phone,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Colors.black;

    Widget textSection = Padding(
      padding: EdgeInsets.all(32),
      child: Text(
        product.desc,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );

    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Detail'),
        ),
        body: ListView (
          children: <Widget>[
            HotelImageWidget(
              id: id,
              isFeatured: product.isFeatured,
              assetName: product.assetName
            ),
            titleSection,
            const Divider(
              height: 1.0,
              color: Colors.black,
            ),
            textSection,
          ],
        ),
      ),
    );
  }
}

class TitleWidget extends StatefulWidget {
  final String name;
  const TitleWidget({Key? key, required this.name}) : super(key: key);

  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<TitleWidget> {

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          widget.name,
          textStyle: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
          speed: const Duration(milliseconds: 200),
        ),
      ],

      totalRepeatCount: 1,
      pause: const Duration(milliseconds: 100),
      displayFullTextOnTap: true,
      stopPauseOnTap: true,
    );
  }
}

class HotelImageWidget extends StatefulWidget {
  final int id;
  final bool isFeatured;
  final String assetName;
  const HotelImageWidget({
    Key? key,
    required this.id,
    required this.isFeatured,
    required this.assetName,
  }) : super(key: key);

  @override
  _HotelImageState createState() => _HotelImageState();
}

class _HotelImageState extends State<HotelImageWidget> {
  int id = 0;
  bool isFeatured = false;
  String assetName = "";
  bool first = true;

  @override
  Widget build(BuildContext context) {

    if (first) {
      id = widget.id;
      isFeatured = widget.isFeatured;
      assetName = widget.assetName;
      first = false;
    }

    return Hero(
      tag: 'hotelImage-' + assetName,
      child: Stack(
        children: [
          Material(
            child: InkWell(
              onDoubleTap: () {
                setState(() {
                  if (isFeatured == true) {
                    print('true');
                    isFeatured = false;
                  } else {
                    print('false');
                    isFeatured = true;
                  }
                  ProductsRepository().changeProduct(id, isFeatured);
                });
              },
              child: Image.asset(
                assetName,
                width: 600,
                height: 240,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: 15,
            right: 15,
            child: Icon(
              isFeatured ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ],
      ) ,
    );
  }
/*
  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }

 */
}
