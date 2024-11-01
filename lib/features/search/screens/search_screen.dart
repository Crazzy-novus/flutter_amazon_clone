import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/features/home/widget/address_box.dart';
import 'package:flutter_amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_amazon_clone/features/search/services/search_service.dart';
import 'package:flutter_amazon_clone/features/search/widget/searched_product.dart';

import '../../../constants/global_variables.dart';
import '../../../models/product.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? product;
  final SearchService searchService = SearchService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSearchProduct();
  }

  fetchSearchProduct() async {
    product = await searchService.fetchSearchProduct(searchQuery: widget.searchQuery, context: context);
    setState(() {});
  }

  void navigateToSearch( String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                      height: 42,
                      margin: const EdgeInsets.only(left: 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(7),
                        elevation: 1,
                        child: TextFormField(
                          onFieldSubmitted: navigateToSearch,
                          decoration: InputDecoration(
                              prefixIcon: InkWell(
                                onTap: () {},
                                child: const Padding(padding: EdgeInsets.only(left: 6),
                                  child: Icon(Icons.search, color: Colors.black),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.only(top: 10),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(color: Colors.black38, width: 1,),
                              ),
                              hintText: 'Search Amazon.in',
                              hintStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              )
                          ),
                        ),
                      )
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Icon(Icons.mic, color: Colors.black, size: 25,),
                )
              ]

          )
      )
  ),
      body: product == null ? const Loader() : Column (
        children: [
          const AddressBox(),
          const SizedBox(height: 10,),
          Expanded(
              child: ListView.builder (
                itemCount: product!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProductDetailsScreen.routeName, arguments: product![index]);
                    },
                      child: SearchedProduct(product: product![index]));
                },
              )
          )
        ]
      )
    );
  }
}
