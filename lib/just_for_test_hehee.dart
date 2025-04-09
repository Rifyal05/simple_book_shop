import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_ecommerce/Authentication/auth_screen.dart';
import 'package:simple_ecommerce/Providers/cart_providers.dart';
import 'package:simple_ecommerce/Providers/user_providers.dart';

// WAIT FOR THE FULL VERSION FOR LOGIN AND AUTHENTICATION YAHHH, HEHE
// STILL BUILDING "^^

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyAppDebug(),
    ),
  );
}
class MyAppDebug extends StatelessWidget {
  const MyAppDebug({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just for Test, hehee..',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}