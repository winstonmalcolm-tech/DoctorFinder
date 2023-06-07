import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doctorapp/providers/EntityProvide.dart';
import 'package:doctorapp/screens/doctorDisplay.dart';
import 'package:doctorapp/screens/entityScreen.dart';
import 'package:doctorapp/screens/homepage.dart';
import 'package:doctorapp/screens/noInternet.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('auth_cache');

  runApp(
    ChangeNotifierProvider(
      create: (context) => EntityProvider(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;
  bool hasInternet = true;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen(_showConnectivitySnackBar);

    internetSubscription = InternetConnectionChecker().onStatusChange.listen((event) {
      final hasInternet = event == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });

  }

  void _showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;

    if (!hasInternet) {
      _showSnackBar(context, "Internet Required");
    } 
  }

  void _showSnackBar(BuildContext context, String? message) {
    final snackBar = SnackBar(content: Text(message!));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void testInternet() async {
    final result = await Connectivity().checkConnectivity();
    _showConnectivitySnackBar(result);
  }

  Widget initialScreen() {
    final authCache = Hive.box("auth_cache");

    if (hasInternet) {
      if (authCache.containsKey(0)) {
        if (authCache.get(0)['med_id'] != null) {
            return const HomePage();
        } else if (authCache.get(0)['institutition_id'] != null) {
            return const DoctorDisplay();
        }
     }

     return const Entity();
    }
     
    return const NoInternet(); 
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: initialScreen(),
      // routes: {
      // '/f': (context) => const Entity(),
      // '/auth': (context) => const Authentication(),
      // '/displayDoctors': (context) => const DoctorDisplay(),
      // '/homepage': (context) => const HomePage(),
      // '/addDoctor': (context) => const AddDoctor(),
      // },
    );
  }
}
