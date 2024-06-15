import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/models/order.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';
import '../../auth/screens/auth_screen.dart';

class AccountServices {
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/user/orders/me'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(context: context, response: res, onSuccess: () {
        var decodedData = jsonDecode(res.body);
        for(int i = 0; i < decodedData["data"].length; i++) {
          orderList.add(
            Order.fromJson(
              jsonEncode(
                  jsonDecode(res.body)["data"][i]
              ),
            ),
          );
        }
      });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
    return orderList;
  }

  void logout({
    required BuildContext context,
  }) async {

    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      Navigator.pushNamedAndRemoveUntil(context, AuthScreen.routeName, (route) => false);

    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

}