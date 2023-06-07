import 'package:doctorapp/providers/EntityProvide.dart';
import 'package:doctorapp/widgets/loginInstitution.dart';
import 'package:doctorapp/widgets/loginNurse.dart';
import 'package:doctorapp/widgets/registerInstitution.dart';
import 'package:doctorapp/widgets/registerNurse.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//url="https://storyset.com/health" -> Health illustrations by Storyset

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {

  EntityProvider ep = EntityProvider();
  int authenticationAction = 1;
  
  showForm(String entity) {
    if (authenticationAction == 2 && entity == 'institution') {
      return Column(
        children: [
          const RegisterInstitution(),
          TextButton(onPressed: () => setState(() {authenticationAction=1;}), child: const Text("Login as Institution")),
        ],
      );
    } else if (authenticationAction == 1 && entity == 'institution') {
        return Column(
          children: [
            const LoginInstitution(),
            TextButton(onPressed: () => setState(() {authenticationAction=2;}), child: const Text("Register as Institution")),
          ],
        );  
    } else if (authenticationAction == 2 && entity == 'nurse') {
      return Column(
        children: [
          const RegisterNurse(),
          TextButton(onPressed: () => setState(() {authenticationAction=1;}), child: const Text("Login as Nurse")),
        ],
      );
    } else if (authenticationAction == 1 && entity == 'nurse') {
      return Column(
        children: [
          const LoginNurse(),
          TextButton(onPressed: () => setState(() {authenticationAction=2;}), child: const Text("Register as Nurse")),
        ],
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,20,0,0),
          child: ListView(
            children: [
              Center(
                child: Text('Doctor Finder', style: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 30, fontStyle: FontStyle.italic)),),
              ),
              Image.asset('assets/nurse.png', height: 250),

              showForm(Provider.of<EntityProvider>(context, listen: false).getEntity),
            ],
          ),
        )
      ),
    );
  }
}