import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'dart:io';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../../models/order.dart';
import '../../../providers/user_provider.dart';
import '../models/sales.dart';

class AdminServices {

  void sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('diy4johah', 'rdo7ixtq');
      List<String> imageUrls = [];
      for (File image in images) {
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, folder: name),
        );
        imageUrls.add(response.secureUrl);
      }
      Product product = Product (
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imageUrls
      );
      http.Response res = await http.post(Uri.parse('$uri/api/admin/add-product'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, 'Product added successfully');
            Navigator.pop(context);

          }
          );

    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }
  // Get All products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/admin/get-product'), headers: {
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

  Future<List<Order>> fetchAllOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/admin/get-orders'), headers: {
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


  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,

  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {

      http.Response res = await http.post(Uri.parse('$uri/api/admin/change-order-status'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      },
        body: jsonEncode({
          'id': order.id,
          'status': status,
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

  Future<Map<String, dynamic>> getEarnings({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarnings = 0;
    try {
      http.Response res = await http.get(Uri.parse('$uri/api/admin/analytics'), headers: {
        'Content-Type': 'application/json',
        'x-auth-token': userProvider.user.token,
      });
      httpErrorHandle(context: context, response: res, onSuccess: () {
        var response = jsonDecode(res.body);
        totalEarnings = response['data']['totalEarnings'];
        sales = [
          Sales('Mobiles', response['data']['mobileEarnings']),
          Sales('Essentials', response['data']['essentialEarnings']),
          Sales('Appliances', response['data']['applianceEarnings']),
          Sales('Books', response['data']['booksEarnings']),
          Sales('Fashion', response['data']['fashionEarnings']),
        ];
        
      });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
    return {
      'totalEarnings': totalEarnings,
      'sales': sales,
    };
  }

}