import 'package:flutter/material.dart';
import 'package:flutter_app/adminChart.dart';
import 'package:flutter_app/adminTransactions.dart';
import 'package:flutter_app/categories.dart';
import 'package:flutter_app/login.dart';
import 'package:flutter_app/product_management.dart';
import 'package:flutter_app/productsPage.dart';
import 'package:flutter_app/shoppingCart/product-list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  final bool isAdmin;
  const NavBar({super.key, required this.isAdmin});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _adminPages = [
    ProductsManagePage(),
    CategoriesPage(),
    AdminTransactions(),
    AdminChart(),
  ];

  Future<void> _clearUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
    await prefs.setBool('rememberMe', false);
  }

  final List<Widget> _userPages = [ProductsPage(), productList()];

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> navItems = widget.isAdmin
        ? [
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory), label: 'Products'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ]
        : [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ];

    final List<Widget> pages = widget.isAdmin ? _adminPages : _userPages;

    return Scaffold(
      body: _selectedIndex < pages.length
          ? Navigator(
              key: ValueKey(
                  _selectedIndex), // Unique key ensures each page is rebuilt
              onGenerateRoute: (_) => MaterialPageRoute(
                builder: (_) => pages[_selectedIndex],
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: (index) async {
          if ((widget.isAdmin && index == 4) ||
              (!widget.isAdmin && index == 2)) {
            bool confirmLogout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                          onPressed: () => {Navigator.of(context).pop(false)},
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () async {
                            await _clearUserCredentials();
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Logout')),
                    ],
                  ),
                ) ??
                false;

            if (confirmLogout) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
