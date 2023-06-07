import 'dart:convert';
import 'package:http/http.dart' as http;

class Doctor {
  int doctorId;
  String firstName;
  String lastName;
  String telephone;
  String? wardName;

  Doctor({required this.doctorId, required this.firstName,required this.lastName, required this.telephone, this.wardName});

}

class Ward {
  int wardId;
  String wardName;
  int institutionId;

  Ward({required this.wardId, required this.wardName, required this.institutionId});
}


class ApiFunctions {

  Future<bool> isInstitutionUsernameAvailable(String username) async {
    try {
      var url = Uri.http('doctorapipro.000webhostapp.com', "api/isInstitutionUsernameAvailable.php", {"username": username});
      var response = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      Map<String, dynamic>? map;

      if (response.statusCode == 200) {
        map = jsonDecode(response.body);
        if (map!['message'] == null) {
          if (map['count']! > 0) {
            return false;
          } else {
            return true;
          }
        }
      } 
      return false;
    } catch(e) {
      print(e);
      return false;
    }
  }

  Future<bool> isNurseUsernameAvailable(String username) async {
    try {
      var url = Uri.http('doctorapipro.000webhostapp.com', 'api/isNurseUsernameAvailable.php', {"username": username});
      var response = await http.get(url);

      Map<String,dynamic> map = json.decode(response.body);

      if (response.statusCode == 200) {
          if (map['count'] > 0) {
            return false;
          } else {
            return true;
          }
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map<String, dynamic>> registerInstitution(Map<String,String> details) async {
    try {
      var url = Uri.http("doctorapipro.000webhostapp.com", "api/registerInstitution.php");
      var response = await http.post(url, headers:{"Content-Type": "application/json"}, body: json.encode(details)); 
      
      if (response.statusCode == 200) {
          Map<String, dynamic> result = jsonDecode(response.body);

          if (result['message'] == null ){
            return result;
          }  else {
            throw result['message'];
          }
      } 

      return {};
      
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> loginInstitution(Map<String,String> loginCredential) async {
    try {
      var url = Uri.https("doctorapipro.000webhostapp.com", "api/loginInstitution.php");
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(loginCredential));
      
      Map<String, dynamic> result = json.decode(response.body);
      
      return result;
      
    } catch(e) {
      print(e.toString());
      throw e;
    }
  }

  Future<List<dynamic>> getInstitutions() async {
    try {
      var url = Uri.http("doctorapipro.000webhostapp.com", "api/getInstitutions.php");
      var response = await http.get(url);
      var result = json.decode(response.body);

      // print(result);
      // print("DATATYPE OF RETURNED DATA ${result.runtimeType}");
      return result;
    } catch(e) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>> RegisterNurse(Map<String, dynamic> registrationDetails) async {
    try {
      var url = Uri.http("doctorapipro.000webhostapp.com", "api/registerNurse.php");
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(registrationDetails));

      var result = json.decode(response.body);

      return result;

    }catch(e) {
      rethrow;
    }
  }

  Future<Map<String,dynamic>> loginNurse(Map<String,String> loginCredentials) async {
    try { 
      var url = Uri.http('doctorapipro.000webhostapp.com', 'api/loginNurse.php');
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(loginCredentials));

      Map<String, dynamic> data = json.decode(response.body);

      return data;

    } catch(e) {
      rethrow;
    }
  }

  Future<List<Doctor>> allDoctors(int med_id) async {
    try {
      var url = Uri.parse('https://doctorapipro.000webhostapp.com/api/getDoctorsAvailableInHospital.php?med_id=$med_id');
      var response = await http.get(url);
    
      List<dynamic> doctorsResult = jsonDecode(response.body);
      
      List<Doctor> doctors = [];

      for(var doctor in doctorsResult) {
        Doctor doc = Doctor(doctorId: doctor['doctor_id'], firstName: doctor['firstName'], lastName: doctor['lastName'], telephone: doctor['telephone'], wardName: doctor['ward_name']);
        doctors.add(doc);
      }

      return doctors;

    } catch(e) {
      print(e);
      throw e;
    }
  }

  Future<List<Doctor>> employedDoctors(int medId) async {
    try {
      var url = Uri.parse('https://doctorapipro.000webhostapp.com/api/getall.php?id=$medId');
      var response = await http.get(url);

      List<dynamic> result = json.decode(response.body);

      List<Doctor> doctors = [];

      if (response.statusCode == 200) {

        for (var doctor in result) {
           Doctor doc = Doctor(doctorId: doctor['doctor_id'], firstName: doctor['firstName'], lastName: doctor['lastName'], telephone: doctor['telephone']);
           doctors.add(doc);
        }

        return doctors;
      }

      return [];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> saveDoctor(Map<String,dynamic> details) async {
    try {
      var url = Uri.http('doctorapipro.000webhostapp.com', 'api/create.php');
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(details));

      Map<String, dynamic> isSaved = json.decode(response.body);

      return isSaved['message']!;

    } catch(e) {
      print(e);
      throw e;
    }
  }

  Future<bool> deleteDoctor(int doctorid) async {
    try {
      var url = Uri.parse('https://doctorapipro.000webhostapp.com/api/delete.php?id=$doctorid');
      var response = await http.get(url);
      Map<String, dynamic> isDeleted = json.decode(response.body);

      return isDeleted['message'];
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> updateDoctor(Map<String, dynamic> details) async {
    try {
      var url = Uri.parse('https://doctorapipro.000webhostapp.com/api/edit.php');
      //var url = Uri.http('192.168.100.7:84', "doctorsapi/api/isInstitutionUsernameAvailable.php", {"username": username});
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(details));
      Map<String, dynamic> isUpdated = json.decode(response.body);
      
      return isUpdated['message'];
    } catch(e) {
      print(e);
      throw e;
    }
  }

  Future<List<Ward>> getWards(int id) async {

    try {
      var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/getWard.php?wardId=$id");
      var response = await http.get(url);
      List<dynamic> wards = json.decode(response.body);

      List<Ward> data = [];

      for (var ward in wards) {
        Ward wa = Ward(wardId: ward['ward_id'], wardName: ward['ward_name'], institutionId: ward['institution_id']);
        data.add(wa);
      }

      return data;
    } catch(e) {
      print(e);
      return [];
    }
   }

   Future<bool> saveWard(Map<String, dynamic> detail) async{
    try {
      var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/newWard.php");
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(detail));

      Map<String, dynamic> result = json.decode(response.body);

      return result['message'];

    } catch(e) {
      print(e);
      return false;
    }
   }

   Future<bool> deleteWard(int wardId) async {
    try {
      var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/deleteWard.php?ward_id=$wardId");
      var response = await http.get(url);
      Map<String,dynamic> isDeleted = json.decode(response.body);

      return isDeleted['message'];

    } catch(e) {
      print(e);
      return false;
    }
   }

   Future<bool> assignToWard(Map<String,int> details) async {
      try {
        var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/newAssignee.php");
        var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(details));

        Map<String, dynamic> data = json.decode(response.body);

        return data['message'];

      } catch(e) {
        print(e);
        return false;
      }
   }

   Future<List<List>> employedDoctorsWard(int medId, int wardId) async {
    try {
      var url = Uri.parse('https://doctorapipro.000webhostapp.com/api/getall.php?id=$medId');
      var response = await http.get(url);

      List<dynamic> result = json.decode(response.body);

      List<List> doctors = [];
      bool isAssigned;

      if (response.statusCode == 200) {

        for (var doctor in result) {
           Doctor doc = Doctor(doctorId: doctor['doctor_id'], firstName: doctor['firstName'], lastName: doctor['lastName'], telephone: doctor['telephone']);
           isAssigned = await isAssignedToWard({"doctor_id": doctor['doctor_id'], "institution_id": medId, "ward_id": wardId});
           doctors.add([doc,isAssigned]);
        }

        return doctors;
      }


      return [];

    } catch (e) {
      print(e);
      throw e;
    }
  }

   Future<bool> isAssignedToWard(Map<String,int> details) async {
      try {
        var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/isAssignedToWard.php");
        var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(details));

        Map<String, dynamic> data = json.decode(response.body);

        return data['message'];
      } catch(e) {
        print(e);
        return false;
      }
   }

   Future<bool> removeAssignee(Map<String,int> details) async {
    try {
      var url = Uri.parse("https://doctorapipro.000webhostapp.com/api/removeAssignee.php");
      var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(details));

      Map<String, dynamic> data = json.decode(response.body);

      return data['message'];

    } catch(e) {
      print(e);
      return false;
    }

   }
}