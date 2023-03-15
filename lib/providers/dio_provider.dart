import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioProvider {
  Future<dynamic> getToken(String email, String password) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/login',
        options: Options(headers: {'Content-Type': 'application/json'}),
          data: {'email': email, 'password': password});
      if (response.statusCode == 200 && response.data != '') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        return true;
      } else {
        return false;
      }
    } catch (error) {

      return error.toString();
    }
  }

  Future<dynamic> getUser(String token) async {
    try {
      var user = await Dio().get('http://127.0.0.1:8000/api/user',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
   
 if (user.statusCode == 200 && user.data != '') {
        return json.encode(user.data);
      }
          } catch (error) {
      return error;
    }
  }
  
    Future<dynamic> getAppointmentsByUser(String token,int user) async {
    try {
      var appointments = await Dio().get('http://127.0.0.1:8000/api/user/$user/appointments',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    
 if (appointments.statusCode == 200 && appointments.data != '') {
        return json.encode(appointments.data);
      }
          } catch (error) {
      return error;
    }
  }


    Future<dynamic> getAllDoctor(String token) async {
    try {
      var doctors = await Dio().get('http://127.0.0.1:8000/api/doctor',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
          
 if (doctors.statusCode == 200 && doctors.data != '') {
        return json.encode(doctors.data);
      }
          } catch (error) {
      return error;
    }
  }





      Future<dynamic> getFavDoctorsByUser(String token,int user) async {
    try {
      var doctors = await Dio().get('http://127.0.0.1:8000/api/user/$user/favoriteDoctors',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
    
 if (doctors.statusCode == 200 && doctors.data != '') {
        return json.encode(doctors.data);
      }
          } catch (error) {
      return error;
    }
  }

  

  Future<dynamic> registerUser(
      String username, String email, String password, String biography) async {
    try {
      var user = await Dio().post('http://127.0.0.1:8000/api/register',
          data: {'name': username, 'email': email, 'password': password, 'biography':biography});
      if (user.statusCode == 200 && user.data != '') {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> bookAppointment(
      String date, 
       String time, int doctor, String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/appointment',
          data: {'date': date, 'time': time, 'doctor_id': doctor},
          options: Options(headers: {'Authorization': 'Bearer $token'}));


      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

    Future<dynamic> cancelAppointment(
    String token, int appointment) async {
    try {
      var response = await Dio().put('http://127.0.0.1:8000/api/appointment/$appointment',
          data: {'status': 'cancel'},
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }


 

  Future<dynamic> storeFavDoc(String token, List<dynamic> favList) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/favoriteDoctor',
          data: {
            'favList': favList,
          },
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }

  Future<dynamic> logout(String token) async {
    try {
      var response = await Dio().post('http://127.0.0.1:8000/api/logout',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.statusCode == 200 && response.data != '') {
        return response.statusCode;
      } else {
        return 'Error';
      }
    } catch (error) {
      return error;
    }
  }
}
