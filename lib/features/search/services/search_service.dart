import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../providers/user_provider.dart';

class SearchService {
  Future<List<Product>> fetchSearchProduct({
    required String searchQuery,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/product/search/$searchQuery'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(context: context, response: res, onSuccess: () {
        var decodedData = jsonDecode(res.body);
        for(int i = 0; i < decodedData["data"].length; i++) {
          productList.add(
            Product.fromJson(
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
    return productList;
  }
}