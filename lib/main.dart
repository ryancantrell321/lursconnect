import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
import "package:lursconnect/screens/login_screen.dart";
import "package:lursconnect/screens/signup_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:lursconnect/screens/forgot_password_screen.dart";
import "package:lursconnect/screens/home_screen.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  
  // Splash Screen Binding
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  // Supabase Setup
  await Supabase.initialize(
    url: "https://jtnzvmifnboddwniadin.supabase.co",
    publishableKey: "sb_publishable_YzNhtBCMdxD21m12DCcM2A_NETUqj6E"
  );

  const rememberMeKey = 'remember_me';
  final preferences = await SharedPreferences.getInstance();
  final rememberMe = preferences.getBool(rememberMeKey) ?? false;
  final client = Supabase.instance.client;
  final savedSession = client.auth.currentSession;
  var initialRoute = '/login';

  if (rememberMe && savedSession != null) {
    try {
      final profile = await client
          .from('profiles')
          .select('status')
          .eq('id', savedSession.user.id)
          .maybeSingle();
      if (profile != null && profile['status'] != 'suspended') {
        initialRoute = '/home';
      }
    } on Exception catch (_) {
      initialRoute = '/login';
    }
  }

  if (initialRoute != '/home' && savedSession != null) {
    await client.auth.signOut();
  }
  
  runApp(lursConnect(initialRoute: initialRoute));
}

class lursConnect extends StatefulWidget {
  final String initialRoute;

  const lursConnect({super.key, this.initialRoute = '/login'});

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
      initialRoute: widget.initialRoute,
      routes: {
        "/login": (context) => const LoginScreen(),
        "/signup": (context) => const SignUpScreen(),
        "/forgot-password": (context) => const ForgotPasswordScreen(),
        "/home": (context) => const HomeScreen(),

        
      }
    );
  }

}
