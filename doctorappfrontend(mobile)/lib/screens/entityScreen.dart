import 'package:doctorapp/screens/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/EntityProvide.dart';

class Entity extends StatefulWidget {
  const Entity({super.key});

  @override
  State<Entity> createState() => _EntityState();
}

class _EntityState extends State<Entity> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff9DCEFF),
              Color(0xff92A3FD)
            ]
          ),

        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Choose your role: ", style: TextStyle(fontSize: 24, color: Colors.white, fontStyle: FontStyle.italic),),
              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder()
                    ),
                    onPressed: () {
                      Provider.of<EntityProvider>(context, listen: false).setEntity("nurse");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authentication()));     
                    }, 
                    child: const Text("Nurse", style: TextStyle(fontSize: 18,color: Colors.blue),)
                  ),
                ),
              ),

              const SizedBox(height: 30),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Provider.of<EntityProvider>(context, listen: false).setEntity("institution");
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Authentication())); 
                    }, 
                    child: const Text("Institution", style: TextStyle(fontSize: 18, color: Colors.white),)
                  ),
                ),
              ),


            ],) 
        ),
      )
    );
  }
}