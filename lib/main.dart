import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:unn_commerce/firebase_options.dart';

import 'package:unn_commerce/screens/auth/login.dart';
import 'package:unn_commerce/screens/main/cart_screen.dart';
import 'package:unn_commerce/screens/main/home_screen.dart';
import 'package:unn_commerce/screens/main/payment_screen.dart';
import 'screens/auth/forgot_password.dart';
import 'screens/auth/sign_up.dart';
import 'screens/auth/verify_email.dart';
import 'screens/intro/splash_screen.dart';
import 'screens/main/profile_screen.dart';
import 'services/auth_services.dart';

final _enabledBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade400),
);
final _focusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade400),
);

final _errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red.shade400),
);

final _focusedErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red.shade700),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AuthService.instance; // ensure created

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNN-Commerce',
      theme: ThemeData(
        primarySwatch: Colors.green,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white,
          strokeWidth: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: _enabledBorder,
          focusedBorder: _focusedBorder,
          errorBorder: _errorBorder,
          focusedErrorBorder: _focusedErrorBorder,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/verify-email': (_) => const VerifyEmailScreen(),
        '/forgot-password': (_) => const ForgotPasswordScreen(),
        '/cart': (_) => const CartScreen(),
        '/home-screen': (_) => const HomeScreen(),
        '/profile': (_) => const ProfileScreen(),
        // '/payment-screen': (_) => const PaymentScreen(),
      },
    );
  }
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/
