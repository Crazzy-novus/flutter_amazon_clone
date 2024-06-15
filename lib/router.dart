import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/bottom_bar.dart';
import 'package:flutter_amazon_clone/features/address/screen/address_screen.dart';
import 'package:flutter_amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:flutter_amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:flutter_amazon_clone/features/cart/screen/cart_screen.dart';
import 'package:flutter_amazon_clone/features/home/screen/category_deals_screen.dart';
import 'package:flutter_amazon_clone/features/home/screen/home_screen.dart';
import 'package:flutter_amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_amazon_clone/features/search/screens/search_screen.dart';
import 'package:flutter_amazon_clone/models/order.dart';
import 'package:flutter_amazon_clone/models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return  MaterialPageRoute (
        builder: (_) => const AuthScreen(),
        settings: routeSettings,
      );
    case HomeScreen.routeName:
      return  MaterialPageRoute (
        builder: (_) => const HomeScreen(),
        settings: routeSettings,
      );
    case BottomBar.routeName:
      return  MaterialPageRoute (
        builder: (_) => const BottomBar(),
        settings: routeSettings,
      );
    case AddProductScreen.routeName:
      return  MaterialPageRoute (
        builder: (_) => const AddProductScreen(),
        settings: routeSettings,
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return  MaterialPageRoute (
        builder: (_) => CategoryDealsScreen(category: category),
        settings: routeSettings,
      );
      case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return  MaterialPageRoute (
      builder: (_) => SearchScreen(searchQuery: searchQuery),
      settings: routeSettings,
      );
    case ProductDetailsScreen.routeName:
      var product = routeSettings.arguments as Product;
      return  MaterialPageRoute (
        builder: (_) => ProductDetailsScreen(product: product),
        settings: routeSettings,
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;
      return  MaterialPageRoute (
        builder: (_) =>  AddressScreen(totalAmount: totalAmount),
        settings: routeSettings,
      );
    case OrderDetailsScreen.routeName:
      var order = routeSettings.arguments as Order;
      return  MaterialPageRoute (
        builder: (_) =>  OrderDetailsScreen(order: order),
        settings: routeSettings,
      );

    case CartScreen.routeName:
      return  MaterialPageRoute (
        builder: (_) => const CartScreen(),
        settings: routeSettings,
      );


    default:
      return  MaterialPageRoute (
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for ${routeSettings.name}'),
          )
        ),
      );
  }
}