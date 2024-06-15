import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/features/account/services/account_services.dart';
import 'package:flutter_amazon_clone/features/account/widgets/single_product.dart';
import 'package:flutter_amazon_clone/features/order_details/screens/order_details_screen.dart';

import '../../../models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  final AccountServices accountServices = AccountServices();
  List<Order>? orders;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountServices.fetchMyOrders(context: context);
    setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return orders == null
        ? const Loader()
        : Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15,),
              child: const Text ("Your Order",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 15,),
              child:  Text ("See All",
                style: TextStyle(
                  fontSize: 18,
                  color: GlobalVariables.selectedNavBarColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
        // Display Orders
        Container(
          height: 200,
          padding: const EdgeInsets.only(left: 10, top: 20, right: 0,),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
              itemCount: orders!.length,

              itemBuilder:( context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: orders![index]);
                  },
                  child: SingleProduct(
                      image: orders![index].products[0].images[0],),
                );
              }
              ),
        )
      ],
    );
  }
}
