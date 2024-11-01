import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_amazon_clone/features/cart/screen/cart_screen.dart';
import 'package:flutter_amazon_clone/features/home/screen/home_screen.dart';
import 'package:flutter_amazon_clone/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../features/account/screens/account_screen.dart';


class BottomBar extends StatefulWidget {

  static const String routeName = '/actual-home';
      const BottomBar({super.key});

      @override
      State<BottomBar> createState() => _BottomBarState();

    }
    class _BottomBarState extends State<BottomBar> {

      int _page = 0;
      double bottomBarWidth = 42;
      double bottomBarBorderWidth = 5;

      List<Widget> pages = [
        const HomeScreen(),
        const AccountScreen(),
        const CartScreen(),

      ];

      void updatePage(int page) {
        setState(() {
          _page = page;
        });
      }

      @override
      Widget build(BuildContext context) {
        final userProvider = context.watch<UserProvider>().user;
        return Scaffold(
          body: pages[_page],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _page,
            selectedItemColor: GlobalVariables.selectedNavBarColor,
            unselectedItemColor: GlobalVariables.unselectedNavBarColor,
            backgroundColor: GlobalVariables.backgroundColor,
            iconSize: 28,
            onTap: updatePage,
            items: [
              // Home
              BottomNavigationBarItem(icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration (
                  border: Border(
                    top: BorderSide (
                      color: _page == 0 ? GlobalVariables.selectedNavBarColor : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    )
                  ),
                ),
                child: const Icon(Icons.home_outlined),
              ),
              label: '',
              ),
              // Account Profile
              BottomNavigationBarItem(icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration (
                  border: Border(
                      top: BorderSide (
                        color: _page == 1 ? GlobalVariables.selectedNavBarColor : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth,
                      )
                  ),
                ),
                child: const Icon(Icons.person_2_outlined),
              ),
              label: ''
              ),
              // Cart
              BottomNavigationBarItem(icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration (
                  border: Border(
                      top: BorderSide (
                        color: _page == 2 ? GlobalVariables.selectedNavBarColor : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth,
                      )
                  ),
                ),
                child:  badges.Badge(
                        badgeStyle: const badges.BadgeStyle(
                          elevation: 0,
                          badgeColor: Colors.white,
                        ),
                        badgeContent: Text(userProvider.cart.length.toString(), style: const TextStyle(color: Colors.black)),
                        child: const Icon(Icons.add_shopping_cart_outlined)
                        )
                ),
              label: ''
              ),
            ]
          ),
        );
      }
    }
