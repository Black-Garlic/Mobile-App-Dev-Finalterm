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

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 40.0),
            Form (
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Username',
                    ),
                    validator: (value) {
                      var regAlpha = RegExp(r'(?=.*?[a-z|A-Z]{1,})');
                      var regNum = RegExp(r'(?=.*?[0-9]{1,})');
                      var alphaCount = 0;
                      var numCount = 0;
                      if (value == null || value.isEmpty) {
                        return 'Please enter Username';
                      } else {
                        for (var i = 0; i < value.length; i++) {
                          if (regAlpha.hasMatch(value[i])) {
                            alphaCount++;
                          } else if (regNum.hasMatch(value[i])) {
                            numCount++;
                          }
                        }
                        if (alphaCount >= 3 && numCount >= 3) {
                          return null;
                        } else {
                          return 'Username is invalid';
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // TODO: Wrap Password with AccentColorOverride (103)
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // TODO: Wrap Password with AccentColorOverride (103)
                  TextFormField(
                    controller: _passwordConfirmController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty || value != _passwordController.text) {
                        return "Confirm Password doesn't match Password";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12.0),
                  // TODO: Wrap Password with AccentColorOverride (103)
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      filled: true,
                      labelText: 'Email Address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email Address';
                      }
                      return null;
                    },
                  ),
                ],
              )
            ),

            ButtonBar(
              children: <Widget>[
                ElevatedButton(
                  child: const Text('SIGN UP'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// TODO: Add AccentColorOverride (103)
