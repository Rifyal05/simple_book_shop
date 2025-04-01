
import 'package:flutter/material.dart';
import 'package:simple_ecommerce/screens/cart.dart';
import 'package:simple_ecommerce/screens/dashboard.dart';
import 'package:simple_ecommerce/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [Dashboard(), const Cart(), const Profile() ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Keranjang"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

