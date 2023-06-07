import 'package:doctorapp/screens/doctorDisplay.dart';
import 'package:doctorapp/screens/doctors.dart';
import 'package:doctorapp/screens/wardScreen.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> screens = const[
    DoctorDisplay(),
    DoctorScreenBottomNav(),
    WardScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Assigned Doctors'
          ),

          BottomNavigationBarItem(
            label: 'Doctors',
            icon: Icon(Icons.person)
          ),

           BottomNavigationBarItem(
            label: 'Add Ward',
            icon: Icon(Icons.medical_services)
          ),
        ]
      ),
    );
  }
}