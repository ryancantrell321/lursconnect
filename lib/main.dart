import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:lursconnect/screens/login_screen.dart";
import "package:lursconnect/screens/signup_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:lursconnect/screens/forgot_password_screen.dart";
import "package:lursconnect/screens/home_screen.dart";

void main() async {
  
  // Splash Screen Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Supabase Setup
  await Supabase.initialize(
    url: "https://jtnzvmifnboddwniadin.supabase.co",
    publishableKey: "sb_publishable_YzNhtBCMdxD21m12DCcM2A_NETUqj6E"
    

  );
  
  runApp(const lursConnect());
}

class lursConnect extends StatefulWidget {
  const lursConnect({super.key});

  @override
  State<lursConnect> createState() => _LursConnectState();

}

class _LursConnectState extends State<lursConnect> {
  
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LURS Connect',
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignUpScreen(),
        "/forgot-password": (context) => const ForgotPasswordScreen(),
        "/home": (context) => const HomeScreen(),

        
      }
    );
  }

}
