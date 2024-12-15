import 'package:flutter/material.dart';
import 'package:flutter_app/adminChart.dart';
import 'package:flutter_app/adminTransactions.dart';
import 'package:flutter_app/categories.dart';
import 'package:flutter_app/product_management.dart';
import 'package:flutter_app/productsPage.dart';
import 'package:flutter_app/shoppingCart/product-list.dart';

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
          ]
        : [
            BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Shop'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Cart'),
          ];

    final List<Widget> pages = widget.isAdmin ? _adminPages : _userPages;

    return Scaffold(
      body: Navigator(
        key:
            ValueKey(_selectedIndex), // Unique key ensures each page is rebuilt
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// class ProductsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(child: Text('Products Page'));
// }

// class CategoriesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(child: Text('Categories Page'));
// }

// class OrdersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(child: Text('Orders Page'));
// }

// class DashboardPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(child: Text('Dashboard Page'));
// }

// class ShopPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(child: Text('Shop Page'));
// }

// class ShoppingCartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) =>
//       Center(child: Text('Shopping Cart Page'));
// }
