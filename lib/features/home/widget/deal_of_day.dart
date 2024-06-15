import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/features/home/services/home_service.dart';
import 'package:flutter_amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_amazon_clone/models/product.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context: context);
    setState(() {});
  }
  void navigateToDetailsScreen() {
    Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    return product == null
    ? const Loader()
    : product!.name.isEmpty
      ? const SizedBox()
      : GestureDetector(
      onTap: navigateToDetailsScreen,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 10, top: 15),
              child: const Text(
                'Deal of the Day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Image.network(
              product!.images[0],
              height: 235,
              fit: BoxFit.fitHeight,
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15),
              child:  Text(
                '\$${product!.price}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(left: 15, top: 5, right: 40),
              child:  Text(
                product!.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: product!.images.map((e) => Image.network(
                  e,
                  fit: BoxFit.fitWidth,
                  width: 100,
                  height: 100,
                ),
                ).toList(),

              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15).copyWith(left: 15),
              alignment: Alignment.topLeft,
              child:  Text(
                "See all deals",
                style: TextStyle(
                  color: Colors.cyan[800],
              ),
              ),
            ),
          ],
        ),
      );
  }
}
