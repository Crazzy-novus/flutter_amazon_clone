import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/custom_button.dart';
import 'package:flutter_amazon_clone/common/widget/stars.dart';
import 'package:flutter_amazon_clone/features/cart/screen/cart_screen.dart';
import 'package:flutter_amazon_clone/features/product_details/services/product_details_services.dart';
import 'package:flutter_amazon_clone/models/product.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../../constants/global_variables.dart';
import '../../search/screens/search_screen.dart';

class ProductDetailsScreen extends StatefulWidget {

  static const String routeName = '/product-details';
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final ProductDetailsService productDetailsService = ProductDetailsService();
  double avgRating = 0;
  double myRating = 0;

  void navigateToSearch( String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void rateProduct(BuildContext context, Product product, double rating) {
    productDetailsService.rateProduct(context: context, product: product, rating: rating);
  }
  void addToCart () {
    productDetailsService.addToCart(context: context, product: widget.product);

  }


  @override
  void initState() {
    super.initState();
    double totalRating = 0;
    if (widget.product.rating != null) {
      for (int i = 0; i < widget.product.rating!.length; i++) {
        totalRating += widget.product.rating![i].rating;
        if (widget.product.rating![i].userId == Provider
            .of<UserProvider>(context, listen: false)
            .user
            .id) {
          myRating = widget.product.rating![i].rating;
        }
      }
      if (totalRating != 0) {
        avgRating = totalRating / widget.product.rating!.length;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.product.id!,
                    ),
                    Stars(rating: avgRating),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 15
                ),
              ),
            ),
            CarouselSlider(
              items:widget.product.images.map(
                    (i) {
                  return Builder(
                    builder: (BuildContext context) => Image.network(
                      i,
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                  );
                },
              ).toList(),
              options: CarouselOptions(viewportFraction:1, height: 300,),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: RichText(
                text: TextSpan(
                  text:"Deal Price: ",
                  style: const TextStyle(
                    fontSize: 16, color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                    text:' \$${widget.product.price}',
                    style: const TextStyle(
                      fontSize: 22, color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                    ),
                  ]
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                widget.product.description
              ),
            ),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CustomButton(
                  text: "Buy Now",
                  radius: 10,
                  onTap: () {
                    addToCart();
                    Navigator.pushNamed(context, CartScreen.routeName);

                  }
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: CustomButton(
                  text: "Add to Cart",
                  radius: 10,
                  color: const Color.fromRGBO(254, 216, 19, 1),
                  onTap: addToCart
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: Colors.black12,
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rate the Product",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            RatingBar.builder(
              initialRating: myRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => const Icon(
              Icons.star,
                color: GlobalVariables.secondaryColor,
              ),
              onRatingUpdate: (rating) {
                rateProduct(
                    context,
                    widget.product,
                    rating
                );
              },
            )

          ],
        ),
      ),
    );
  }
}
