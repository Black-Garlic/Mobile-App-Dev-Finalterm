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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrine/detail.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/products_repository.dart';
import 'model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final isSelected = <bool>[true, false];
  List<Product> products = ProductsRepository().loadProducts();
  List<int> favorite = List.generate(0, (index) => 0);

  List<Card> _buildGridCards(BuildContext context) {
    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 12,
              child: Hero(
                tag: 'hotelImage-' + product.assetName,
                child: Image.asset(
                  product.assetName,
                  fit: BoxFit.fitWidth,
                ),
              )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Icon(product.star >= 1 ? Icons.star: Icons.star_border, color: Colors.yellow),
                        Icon(product.star >= 2 ? Icons.star: Icons.star_border, color: Colors.yellow),
                        Icon(product.star >= 3 ? Icons.star: Icons.star_border, color: Colors.yellow),
                      ],
                    ),
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
                      product.address,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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
                print(product.id);
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
                  )
                );
              },
            )
          ],
        ),
      );
    }).toList();
  }

  Card _buildListCard(BuildContext context, int index) {
    Product product = products[index];
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: Image.asset(
          product.assetName,
          fit: BoxFit.fitWidth,
        ),
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(product.star >= 1 ? Icons.star: Icons.star_border, color: Colors.yellow),
                  Icon(product.star >= 2 ? Icons.star: Icons.star_border, color: Colors.yellow),
                  Icon(product.star >= 3 ? Icons.star: Icons.star_border, color: Colors.yellow),
                ],
              ),
              Text(product.name),
            ]
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(product.address),
            TextButton(
              child: const Text(
                'more',
                textAlign: TextAlign.end,
              ),
              onPressed: () {
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
            ),
          ],
        ),
      ),
    );
  }

  Future<void>? _launched;

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.language,
              semanticLabel: 'filter',
            ),
            onPressed: () => setState(() {
              _launched = _launchInBrowser("https://www.handong.edu/");
            }),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              padding:EdgeInsets.fromLTRB(20, 110, 10, 0),
              child: Text(
                'Pages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                semanticLabel: 'home',
                color: Colors.blue,
              ),
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.search,
                semanticLabel: 'search',
                color: Colors.blue,
              ),
              title: const Text('Search'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.location_city,
                semanticLabel: 'location_city',
                color: Colors.blue,
              ),
              title: const Text('Favorite Hotel'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/favorite');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.person,
                semanticLabel: 'person',
                color: Colors.blue,
              ),
              title: const Text('My Page'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/my page');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                semanticLabel: 'logout',
                color: Colors.blue,
              ),
              title: const Text('Log Out'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding (
            padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: ToggleButtons(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(Icons.view_list),
                const Icon(Icons.grid_view),
              ],
              isSelected: isSelected,
              onPressed: (index) {
                // Respond to button selection
                setState(() {
                  for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = true;
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
            ),
          ),

          Expanded(
            child: isSelected[0] ?
              OrientationBuilder(
                builder: (context, orientation) {
                  return GridView.count(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    padding: const EdgeInsets.all(16.0),
                    childAspectRatio: 8.0 / 12.0,
                    children: _buildGridCards(context),
                  );
                }
              )
             :
              ListView.builder (
                itemCount: products.length,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: (BuildContext context, int index){
                  return _buildListCard(context, index);
                },
              ),
          )
        ],
      ),
    );
  }
}
