import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/stars.dart';
import 'package:flutter_amazon_clone/models/product.dart';

class SearchedProduct extends StatelessWidget {
  final Product product;
  const SearchedProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double totalRating = 0;
    double avgRating = 0;
    if (product.rating != null) {
      for (int i = 0; i < product.rating!.length; i++) {
        totalRating += product.rating![i].rating;

      }
      if (totalRating != 0) {
        avgRating = totalRating / product.rating!.length;
      }
    }
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
          child: Row (
            children: [
              Image.network(
                product.images[0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text (
                      product.name,
                      style: const TextStyle (
                        fontSize: 16,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Stars(rating: avgRating),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text (
                      '\$${product.price}',
                      style: const TextStyle (
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: const Text (
                      'Eligible for FREE Shipping',
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: const Text (
                      'In Stock',
                      style: TextStyle (
                        color: Colors.teal
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              )

            ],
          ),
        )
      ],
    );
  }
}
