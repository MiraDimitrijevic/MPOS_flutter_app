import 'dart:convert';

import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool _isLogin = false;
  Map<String, dynamic> user = {}; 
  Map<String, dynamic> appointment =
      {}; 
  Map<String, dynamic> favDoc = {}; 
  List<dynamic> _fav = []; 

  bool get isLogin {
    return _isLogin;
  }

  List<dynamic> get getFav {
    return _fav;
  }

  Map<String, dynamic> get getUser {
    return user;
  }

  Map<String, dynamic> get getAppointment {
    return appointment;
  }

  void setFavList(List<dynamic> list) {
    _fav = list;
    notifyListeners();
  }

  Map<String, dynamic> get getFavDoc {

    return favDoc;
  }

  void loginSuccess(
      Map<String, dynamic> userData, Map<String, dynamic> appointmentInfo, Map<String, dynamic>  doctors ,  List<dynamic> favDocs) {
    _isLogin = true;

    user = userData;
    appointment = appointmentInfo;
    favDoc=doctors;
    _fav=favDocs;


    notifyListeners();
  }
}
