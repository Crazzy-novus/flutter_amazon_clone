
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/common/widget/bottom_bar.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../providers/user_provider.dart';
class AuthService {

  // Sign Up user
  void signUpUser ({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
}) async {
     
      try {
        User user = User(id: '', name: name, email: email, password: password, address: '', type: '', token: '', cart: []);
        http.Response res = await http.post(Uri.parse('$uri/api/auth/register'), body: user.toJson(), headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        httpErrorHandle(response: res,
            context: context,
            onSuccess: () {
              showSnackBar(context, "Account created successfully");

        });

      } catch (error) {
        showSnackBar(context, error.toString());

    }

  }

  // Sign In user
  void signInUser ({
    required BuildContext context,
    required String email,
    required String password,
  })
  async {
      try {
        http.Response res = await http.post(Uri.parse('$uri/api/auth/login'), body: jsonEncode(
            {'email': email,
              'password': password
            }),
            headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        httpErrorHandle(response: res,
            context: context,
            onSuccess: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var decodedData = jsonDecode(res.body);
              var data = decodedData["data"];
              Provider.of<UserProvider>(context, listen: false).setUser(jsonEncode(data));
              var token = data['token'];
              if (token != null) {
                await prefs.setString('x-auth-token', token);
                Navigator.pushReplacementNamed(context, BottomBar.routeName);
              } else {
                showSnackBar(context, "Internal Server error occurred");
                throw Exception('Token is null');
              }
            });
      }
      catch (error) {
        showSnackBar(context, error.toString());
      }
  }

  // Get User data
  void getUserData ({
    required BuildContext context,
  }) async {
    try {


      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      //  http.Response tokenRes = await http.post(Uri.parse('$uri/api/auth/tokenIsValid'),
      //      headers: <String, String> {
      //        'Content-Type': 'application/json; charset=UTF-8',
      //        'x-auth-token': token!
      //      });
      //
      // var responseDecode = jsonDecode(tokenRes.body);
      // var response = responseDecode["success"];


      if (token != null && token.isNotEmpty) {
        http.Response userRes = await http.get(Uri.parse('$uri/api/auth/'),
            headers: <String, String> {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            });

        var decodedData = jsonDecode(userRes.body);
        var data = decodedData["data"];
        Provider.of<UserProvider>(context, listen: false).setUser(jsonEncode(data));
      }
      else{
        showSnackBar(context, "Token is null");
      }

    } catch (error) {
      showSnackBar(context, "error");
    }
  }
}