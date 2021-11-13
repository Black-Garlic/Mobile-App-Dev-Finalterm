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

import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';           // new

import 'main.dart';
import 'src/authentication.dart';                  // new
import 'src/widgets.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset(
                  'assets/garlic_icon.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16.0),
              ],
            ),
            const SizedBox(height: 120.0),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => ElevatedButton(
                child: const Text('Google'),
                onPressed: () async {
                  appState.signInWithGoogle(context);
                },
              ),
            ),
            const SizedBox(height: 12.0),
            Consumer<ApplicationState>(
              builder: (context, appState, _) => ElevatedButton(
                child: const Text('Guest'),
                onPressed: () {
                  appState.signInAnonymous(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}