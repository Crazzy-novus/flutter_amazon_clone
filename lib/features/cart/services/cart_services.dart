import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../models/user.dart';

class CartServices {

  void removeFromCart( {
    required BuildContext context,
    required Product product,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.delete(
        Uri.parse ('$uri/api/user/remove-from-cart/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            var decodedData = jsonDecode(res.body);
            var data = decodedData["data"]['cart'];
            User user = userProvider.user.copyWith(cart: data);
            userProvider.setUserFromModel(user);
            showSnackBar(context, 'Product added to cart successfully');

          }
      );

    } catch (error) {
      showSnackBar(context, error.toString());
    }


  }

}