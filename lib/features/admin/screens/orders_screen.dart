import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/features/account/widgets/single_product.dart';
import 'package:flutter_amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter_amazon_clone/features/order_details/screens/order_details_screen.dart';

import '../../../models/order.dart';
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  List<Order>? orders;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllOrders();
  }

  void fetchAllOrders() async {
    orders = await adminServices.fetchAllOrders(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
    ? const Loader()
    : GridView.builder(
      itemCount: orders!.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        final orderDate = orders![index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, OrderDetailsScreen.routeName, arguments: orderDate);
          },
          child: SizedBox(height: 140,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 05),
              child: SingleProduct(
                image: orderDate.products[0].images[0],

              ),
            ),
          ),
        );
      },
    );
  }
}
