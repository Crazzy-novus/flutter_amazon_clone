import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/loader.dart';
import 'package:flutter_amazon_clone/features/account/widgets/single_product.dart';
import 'package:flutter_amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:flutter_amazon_clone/features/admin/services/admin_services.dart';

import '../../../models/product.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final AdminServices adminServices = AdminServices();
  List<Product>? products;

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName).then(
      // Call Back function It will active when return back to Post Screen
      (_) => fetchAllProducts()
    );
  }

  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
        product: product,
        context: context,
        onSuccess: () {
          products!.removeAt(index);
          setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Loader()
        : Scaffold(
          body: GridView.builder(
            itemCount: products!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              final productData = products![index];
              return Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: SingleProduct(
                        image: productData.images[0],
                  ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => deleteProduct(productData, index),
                        icon: const Icon(Icons.delete_outline)
                      )
                    ],
                  )
                ],
              ) ;
            }
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: FloatingActionButton(

              onPressed: navigateToAddProduct,
              tooltip: "Add Product",
              child: const Icon(Icons.add)
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        );
  }
}
