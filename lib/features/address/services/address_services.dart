import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/user.dart';
import '../../../providers/user_provider.dart';

class AddressServices {
  void saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {

      http.Response res = await http.post(Uri.parse('$uri/api/user/save-address'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      },
        body: jsonEncode({
          'address': address,
        }
        )
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var decoded = jsonDecode(res.body);
            User user = userProvider.user.copyWith(
                address: decoded["data"]["address"],
            );
            userProvider.setUserFromModel(user);
          }
      );

    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
  // Get All products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,

  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(Uri.parse('$uri/api/user/order'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      },
      body: jsonEncode({
        'address': address,
        'cart': userProvider.user.cart,
        'totalPrice': totalSum.toString(),
      }

      )

      );
      httpErrorHandle(context: context, response: res, onSuccess: () {
        User user = userProvider.user.copyWith(
          cart: [],
        );
        userProvider.setUserFromModel(user);
        showSnackBar(context, "Your Order has Been placed");
      });
    } catch (error) {

      showSnackBar(context, error.toString());
    }
  }
  // Deleting Product Api
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {

      http.Response res = await http.delete(Uri.parse('$uri/api/admin/delete-product'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      },
        body: jsonEncode({
          'id': product.id,
        }),
      );
      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            onSuccess();
          }
      );

    } catch (error) {
      showSnackBar(context, error.toString());
    }

  }

}