import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:localstore/localstore.dart';

import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/components/custom_suffix_icon.dart';
import 'package:flutter_application_1/components/default_button.dart';
import 'package:flutter_application_1/components/form_error.dart';
import 'package:flutter_application_1/screens/home/home_screen.dart';
import 'package:flutter_application_1/size_config.dart';
import 'package:flutter_application_1/services/loginService.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  final List<String> errors = [];

  void addError({String error = ''}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error = ''}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            buildEmailFormField(),
            FormError(
                error: errors.contains(kEmailNullError) ? kEmailNullError : ''),
            FormError(
                error: errors.contains(kInvalidEmailError)
                    ? kInvalidEmailError
                    : ''),
            SizedBox(height: getProportionateScreenHeight(32)),
            buildPasswordFormField(),
            FormError(
                error: errors.contains(kPassNullError) ? kPassNullError : ''),
            SizedBox(height: getProportionateScreenHeight(24)),
            FormError(
                error: errors.contains(kEmailOrPasswordError)
                    ? kEmailOrPasswordError
                    : ''),
            FormError(
                error: errors.contains(kSomethingWrongError)
                    ? kSomethingWrongError
                    : ''),
            SizedBox(height: getProportionateScreenHeight(24)),
            DefaultButton(
                text: "Login",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Map<String, dynamic> loginData = {
                      'email': email,
                      'password': password
                    };

                    var loginResult =
                        await LoginService().authenticate(loginData);

                    if (loginResult['status'] == 200) {
                      String token = loginResult['token'];

                      // Decode JWT token
                      Map<String, dynamic> payload = Jwt.parseJwt(token);

                      // Get localstore instance and save token
                      final db = await Localstore.instance;
                      db.collection('login').doc('loginData').set(payload);

                      // Navigate to home page
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    } else if (loginResult['status'] == 401) {
                      addError(error: kEmailOrPasswordError);
                    } else {
                      addError(error: kSomethingWrongError);
                    }
                  }
                })
          ],
        ));
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kEmailNullError);
          } else if (emailValidatorRegExp.hasMatch(value)) {
            removeError(error: kInvalidEmailError);
          }
          return null;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kEmailNullError);
            return "";
          } else if (!emailValidatorRegExp.hasMatch(value)) {
            addError(error: kInvalidEmailError);
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: CustomSuffixIcon(svgIcon: 'assets/icons/Mail.svg')));
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        removeError(error: kEmailOrPasswordError);
        removeError(error: kSomethingWrongError);
        password = value;
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: 'assets/icons/Lock.svg',
          )),
    );
  }
}
