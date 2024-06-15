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

class ProductDetailsService {
  void rateProduct( {
    required BuildContext context,
    required Product product,
    required double rating,
}) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse ('$uri/api/product/rate-product'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Product rated successfully');
        }
      );

    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

  void addToCart( {
    required BuildContext context,
    required Product product,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse ('$uri/api/user/add-to-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
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