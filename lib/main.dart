import "package:flutter/material.dart";
import "package:flutter_native_splash/flutter_native_splash.dart";
// import "package:lursconnect/screens/homepage.dart";
import "package:lursconnect/screens/login_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";

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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 8, 16, 49),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
