import "package:flutter/material.dart";

class BackgroundScreen extends StatelessWidget{
  
  // allow acceptance of other widgets
  final Widget child;
  final Widget? drawer;
  const BackgroundScreen({super.key, required this.child, this.drawer});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // BG Image
          Positioned.fill(child: Image.asset("assets/img/LURS_Background_dark.png", fit: BoxFit.cover,)),
          
          SafeArea(
            child: SizedBox.expand(child: child)
            ), //Screen contents,
        ])
    );

  }
}
