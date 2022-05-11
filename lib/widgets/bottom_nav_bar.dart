import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:my_shop/controllers/auth_controller.dart';
import 'package:my_shop/screens/cart.dart';
import 'package:my_shop/screens/home.dart';
import 'package:my_shop/screens/main_screen.dart';

import '../controllers/home_controller.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationTravelkuyState createState() =>
      _BottomNavigationTravelkuyState();
}

class _BottomNavigationTravelkuyState extends State<BottomNavigation> {
  int _selectedIndex = 0;
  /*var bottomTextStyle =
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500);*/
  final AuthController controller = Get.put(AuthController());
  void _onItemTapped(int index) {
    _selectedIndex = index;
    if (index == 0) {
      Get.to(() => HomePage());
    } else if (index == 1) {
      Get.to(() => CartPage());
    } else if (index == 2) {
      controller.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.yellow[900],
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: GetX<MainController>(builder: (logic) {
              return IconBadge(
                icon: const Icon(Icons.shopping_cart),
                itemCount: logic.carts.value.length,
                badgeColor: Colors.red,
                itemColor: Colors.white,
                onTap: () {
                  Get.to(() => CartPage());
                },
              );
            }),
            label: 'Chart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'logOut',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.shopping_cart),
          //   label: 'Cart Request',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        backgroundColor: Colors.indigo,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        elevation: 0,
      ),
    );
  }
}
