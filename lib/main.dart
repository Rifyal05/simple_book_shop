import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_ecommerce/Navigaton/home_page.dart';
import 'Onboarding/onboarding_page.dart';
import 'Providers/cart_providers.dart';
import 'Providers/user_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(hasSeenOnboarding: hasSeenOnboarding),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Test',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),

      // If you want to see the onboarding page only once,
      // Uncomment line 40 and then comment out line 41
      // home: hasSeenOnboarding ? const HomePage() : const OnboardingPage(), // Uncomment this line to see the onboarding page once
      home: hasSeenOnboarding ? const OnboardingPage() : const HomePage(),    // Comment out this line after uncommenting the line above
    );
  }
}