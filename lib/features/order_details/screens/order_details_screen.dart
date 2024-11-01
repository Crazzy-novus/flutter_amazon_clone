import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/custom_button.dart';
import 'package:flutter_amazon_clone/features/admin/services/admin_services.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants/global_variables.dart';
import '../../../models/order.dart';
import '../../search/screens/search_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  final Order order;
  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}


class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  final AdminServices adminServices = AdminServices();
  int currentStep = 0;
  void navigateToSearch( String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
  // !!! Only for Admin !!!

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentStep = widget.order.status;
  }

  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(context: context, order: widget.order, status: status + 1, onSuccess: () {
      setState(() {
        currentStep += 1;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
  final user = Provider.of<UserProvider>(context, listen: false).user;
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
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "View Order Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Date:       ${DateFormat().format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderAt)) }',
                    ),
                    Text(
                      'Order Id:            ${widget.order.id}',
                    ),
                    Text(
                      'Total Amount:   ${widget.order.totalPrice}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Purchase Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (int i = 0; i < widget.order.products.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        child: Row(
                          children: [
                            Image.network(widget.order.products[i].images[0],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.order.products[i].name,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Quantity: ${widget.order.quantity[i]}',
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Tracking",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                    )
                ),
                child: Stepper(
                  currentStep: currentStep > 3 ? 3 : currentStep,
                  controlsBuilder: (context, details) {
                    if (user.type == 'admin' && currentStep < 3) {
                      return CustomButton(text: 'Done', radius: 10,onTap: () => changeOrderStatus(details.currentStep),);
                    }
                    return const SizedBox();
                  },
                  steps: [
                    Step(
                      title: const Text('Pending'),
                      content: const Text("Your order is yet to be delivered",),
                      isActive: currentStep > 0,
                      state: currentStep > 0 ? StepState.complete : StepState.indexed

                    ),
                    Step(
                      title: const Text('Completed'),
                      content: const Text("Your order has Been delivered, you are yet to sign",),
                      isActive: currentStep > 1,
                        state: currentStep > 1 ? StepState.complete : StepState.indexed
                    ),
                    Step(
                      title: const Text('Received'),
                      content: const  Text("Your order has been delivered and Signed by you ",),
                      isActive: currentStep > 2,
                        state: currentStep > 2 ? StepState.complete : StepState.indexed
                    ),
                    Step(
                      title: const Text('Delivered'),
                      content: const Text("Your order has been delivered and Signed by you ",),
                      isActive: currentStep >= 3,
                        state: currentStep >= 3 ? StepState.complete : StepState.indexed
                    )
                  ]
                )
              )
            ],
          ),
        ),
      ),

    ) ;
  }
}
