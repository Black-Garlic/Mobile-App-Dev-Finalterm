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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';           // new
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'model/item.dart';
import 'src/authentication.dart';                  // new
import 'src/widgets.dart';

import 'app.dart';

void main() {
  // Modify from here
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => const ShrineApp(),
    ),
  );
  // to here.
}

enum ApplicationLoginState {
  loggedOut,
  emailAddress,
  register,
  password,
  loggedIn,
}

class ApplicationState extends ChangeNotifier {

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;
  ApplicationLoginState get loginState => _loginState;

  String? _email;
  String? get email => _email;

  StreamSubscription<QuerySnapshot>? _itemSubscription;
  List<Item> _item = [];
  List<Item> get item => _item;

  late UserCredential _user;
  UserCredential get user => _user;

  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        initStream();
        if (FirebaseAuth.instance.currentUser!.isAnonymous) {
          addNewUser('anonymous');
        } else {
          addNewUser('google');
        }

      } else {
        cancelStream();
      }
      notifyListeners();
    });
  }

  void initStream() {
    _itemSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('price')
        .snapshots()
        .listen((snapshot) {
      _item = [];
      for (final document in snapshot.docs) {
        _item.add(
          Item(
            id: document.id,
            name: document.data()['name'] as String,
            desc: document.data()['desc'] as String,
            price: document.data()['price'] as int,
            image: document.data()['image'] as String,
            uid: document.data()['uid'] as String,
            regDate: document.data()['regDate'].toDate() as DateTime,
            modDate: document.data()['modDate'].toDate() as DateTime,
          ),
        );
      }
      notifyListeners();
    });
  }

  void cancelStream() {
    _item = [];
    _itemSubscription?.cancel();
  }

  void sortProduct(bool asc) {
    if (asc) {
      _item.sort((a, b) => a.price.compareTo(b.price));
    } else {
      _item.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  void editProduct(int index, String name, int price, String desc, String image, DateTime modDate) async {
    _item[index] = Item(
        id: _item[index].id,
        name: name,
        desc: desc,
        price: price,
        image: image,
        uid: item[index].uid,
        regDate: item[index].regDate,
        modDate: modDate,
    );
    notifyListeners();
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  void signInWithGoogle(context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    _user = await FirebaseAuth.instance.signInWithCredential(credential);
    Navigator.pushNamed(context, '/');
  }

  void signInAnonymous(context) async {
    // Once signed in, return the UserCredential
    _user = await FirebaseAuth.instance.signInAnonymously();
    Navigator.pushNamed(context, '/');
  }

  void addNewUser(type) async {
    print("check user");
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (final document in _myDoc.docs) {
      return;
    }
    print("new user");
    if (type == 'google') {
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'email': FirebaseAuth.instance.currentUser!.email,
        'name': FirebaseAuth.instance.currentUser!.displayName,
        'status_message': "I promise to take the test honestly before GOD",
      });
    } else {
      FirebaseFirestore.instance
          .collection('user')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'status_message': "I promise to take the test honestly before GOD",
      });
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}

class LoginProvider extends ChangeNotifier {

}

class DropDownProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _itemSubscription;
  List<Item> _item = [];
  List<Item> get item => _item;

  DropDownProvider() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        initStream();
      } else {
        cancelStream();
      }
      notifyListeners();
    });
  }

  void initStream() {
    _itemSubscription = FirebaseFirestore.instance
        .collection('product')
        .orderBy('price')
        .snapshots()
        .listen((snapshot) {
      _item = [];
      for (final document in snapshot.docs) {
        _item.add(
          Item(
            id: document.id,
            name: document.data()['name'] as String,
            desc: document.data()['desc'] as String,
            price: document.data()['price'] as int,
            image: document.data()['image'] as String,
            uid: document.data()['uid'] as String,
            regDate: document.data()['regDate'].toDate() as DateTime,
            modDate: document.data()['modDate'].toDate() as DateTime,
          ),
        );
      }
      notifyListeners();
    });
  }

  void cancelStream() {
    _item = [];
    _itemSubscription?.cancel();
  }

  void sortProduct(bool asc) {
    if (asc) {
      _item.sort((a, b) => a.price.compareTo(b.price));
    } else {
      _item.sort((a, b) => b.price.compareTo(a.price));
    }
  }
}