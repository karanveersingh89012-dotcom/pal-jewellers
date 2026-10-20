import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'home_screen.dart';
import 'product_catalog_screen.dart';
import 'visit_us_screen.dart';

class CustomerShellScreen extends StatefulWidget {
  const CustomerShellScreen({super.key});

  @override
  State<CustomerShellScreen> createState() => _CustomerShellScreenState();
}

class _CustomerShellScreenState extends State<CustomerShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductCatalogScreen(),
    VisitUsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.subtleDivider,
              width: 0.8,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: AppColors.creamBackground,
          selectedItemColor: AppColors.deepBrown,
          unselectedItemColor: AppColors.deepBrown.withValues(alpha: 0.4),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: "Catalog",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.storefront_outlined),
              activeIcon: Icon(Icons.storefront),
              label: "Visit Us",
            ),
          ],
        ),
      ),
    );
  }
}