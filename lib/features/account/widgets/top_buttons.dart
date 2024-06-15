import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/features/account/services/account_services.dart';
import 'package:flutter_amazon_clone/features/account/widgets/account_button.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(
              text: "Your Order",
              onTap: () {}
            ),
            AccountButton(
              text: "Turn Seller",
              onTap: () {}
            ),
          ],
        ),
        const SizedBox(height:10),
        Row(
          children: [
            AccountButton(
                text: "Logout",
                onTap: () => AccountServices().logout(context: context)
            ),
            AccountButton(
                text: "Your Wish List",
                onTap: () {}
            ),
          ],
        ),
      ],
    );
  }
}
