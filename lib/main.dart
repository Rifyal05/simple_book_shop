import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Onboarding/onboarding_page.dart';
import 'package:simple_ecommerce/Authentication/auth_screen.dart';
import 'package:simple_ecommerce/Providers/cart_providers.dart';
import 'package:simple_ecommerce/Providers/user_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? true; // Change to true(if line 41 uncommented)

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
      // WARNING!! PLEASE READ CAREFULLY!! DO ONE BY ONE, STEP-BY-STEP!!.
      // If you want to see the onboarding page only once,
      // Uncomment line 41 and then comment out line 42:
      // home: hasSeenOnboarding ? const AuthScreen() : const OnboardingPage(), // Uncomment this line to see the onboarding page once
      home: hasSeenOnboarding ? const OnboardingPage() : const AuthScreen(), // Comment out this line after uncommenting the line above
      // Then, change the value in line 13 to `false`.
      // If line 42 is uncommented (do this if you want to modify the onboarding page),
      // then the value in line 13 should be `true/false(better true)'.
      // If you have already run the code and saw the onboarding page
      // when the application launched, and subsequently modified the code
      // (by uncommenting line 41 and commenting out line 42),
      // you might notice upon rerunning the application
      // that you do not see the onboarding page again.
      // This happens because you have already viewed the onboarding page previously
      // (and the application likely saved this state).
      // So, if you want the onboarding page to appear again (specifically,
      // to test and confirm that it appears exactly once on the very first launch),
      // you need to uninstall the application currently installed on your emulator
      // or device and then run the code again.
      // This action simulates a fresh install and resets the 'seen' status."
      // YOU NEED TO UNDERSTAND THIS!!
      // SORRY FOR MY BROKEN ENGLISH!! \(>_<)/
    );
  }
}