import 'package:flutter/material.dart';


class NoInternet extends StatelessWidget {
  const NoInternet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/no_internet.png', height: 350),
          const Center(child: Text("No Internet", style: TextStyle(fontSize: 18),))
        ]
      ),
    );
  }
}