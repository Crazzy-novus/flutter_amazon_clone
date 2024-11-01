import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/common/widget/bottom_bar.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/address/services/address_services.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

import '../../../common/widget/custom_button.dart';
import '../../../common/widget/custom_textfield.dart';
import '../../../constants/global_variables.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  final TextEditingController flatController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String addressToBeUsed = '';
  List<PaymentItem> paymentItems = [];
  final AddressServices addressServices = AddressServices();

  String get defaultGooglePayConfigString {
    return '''
  {
    "provider": "google_pay",
    "data": {
      "environment": "TEST",
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "allowedPaymentMethods": [
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "example",
              "gatewayMerchantId": "gatewayMerchantId"
            }
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {
              "format": "FULL",
              "phoneNumberRequired": true
            }
          }
        }
      ],
      "merchantInfo": {
        "merchantId": "01234567890123456789",
        "merchantName": "Example Merchant Name"
      },
      "transactionInfo": {
        "countryCode": "US",
        "currencyCode": "USD"
      }
    }
  }
  ''';

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentItems.add(PaymentItem(
      label: 'Total Amount',
      amount: widget.totalAmount,
      status: PaymentItemStatus.final_price,
    ));
  }

  final _addressFormKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    flatController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();

  }


  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false)
        .user
        .address
        .isEmpty) {
      addressServices.saveUserAddress(
          context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalSum: double.parse(widget.totalAmount),
    );
  }

  void onGooglePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: true).user.address.isEmpty) {
      addressServices.saveUserAddress(context: context, address: addressToBeUsed);
    }
    addressServices.placeOrder(context: context, address: addressToBeUsed, totalSum:double.parse(widget.totalAmount) );
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    bool isForm = flatController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;

    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
        '${flatController.text}, ${areaController.text}, ${cityController.text} - ${pincodeController.text}';
      } else {
        throw Exception('Please enter all the values!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Please enter all the values!');
      throw Exception('Please enter all the values!');
    }
  }

  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: GlobalVariables.appBarGradient,
              ),
            ),
          )
        ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (address.isNotEmpty)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(controller: flatController, hintText: "Flat, House no, Building"),
                    const SizedBox(height: 10),
                    CustomTextField(controller: areaController, hintText: "Area, Street"),
                    const SizedBox(height: 10),
                    CustomTextField(controller: pincodeController, hintText: "Pincode"),
                    const SizedBox(height: 10),
                    CustomTextField(controller: cityController, hintText: "Town/City"),
                    const SizedBox(height: 10),
                    CustomButton(
                        text: 'Case On Delivery',
                        radius: 5,
                        onTap: () {
                          payPressed(address);
                          if (Provider.of<UserProvider>(context, listen: false).user.address.isEmpty) {
                            addressServices.saveUserAddress(context: context, address: addressToBeUsed);
                          }
                          addressServices.placeOrder(context: context, address: addressToBeUsed, totalSum:double.parse(widget.totalAmount) );
                          Navigator.pushNamed(context, BottomBar.routeName);
                        }
                    )
                  ],
                ),
              ),

              const SizedBox(height: 10),
             GooglePayButton(
               onPressed: () => payPressed(address),
               paymentItems: paymentItems,
               paymentConfiguration: PaymentConfiguration.fromJsonString(
                   defaultGooglePayConfigString),
               onPaymentResult: onGooglePayResult,
               height: 50,
               width: double.infinity,
               type: GooglePayButtonType.buy,
               margin: const EdgeInsets.only(top: 15),
               loadingIndicator: const Center(child: CircularProgressIndicator(),),
             )
            ],
          ),
        ),
      ),
    );
  }
}
