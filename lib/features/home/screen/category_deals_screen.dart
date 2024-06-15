import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/features/home/services/home_service.dart';
import 'package:flutter_amazon_clone/features/product_details/screens/product_details_screen.dart';

import '../../../constants/global_variables.dart';
import '../../../models/product.dart';

class CategoryDealsScreen extends StatefulWidget {
  final  String category;
  static const String routeName = '/category-deals';

  const CategoryDealsScreen({super.key, required this.category});


  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {

  List<Product>? productList;
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchCategoryProduct();
  }
  fetchCategoryProduct() async {
    productList = await homeServices.fetchCategoryProduct(
        category: widget.category,
        context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
              title: Text(
                  widget.category,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
              ),
          )
      ),
      body: productList == null
        ? const Loader()
        : Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            alignment: Alignment.topLeft,
            child: Text(
              'Keep shopping for ${widget.category}',
            style: const TextStyle(
              fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                ),
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(left: 10, right: 15),
              itemCount: productList!.length,

            itemBuilder: (context, index) {
                final product = productList![index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product);
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: 130,
                      width: 140,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                            width: 0.5,
                          ),
                          ),
                        child: Padding(
                        padding: const EdgeInsets.all(10),
                          child: Image.network(product.images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 5,top: 5,right: 15),
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(

                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
