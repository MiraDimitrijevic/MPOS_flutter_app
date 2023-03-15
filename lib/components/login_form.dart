import 'dart:convert';

import 'package:doctor_app/components/button.dart';
import 'package:doctor_app/main.dart';
import 'package:doctor_app/models/auth_model.dart';
import 'package:doctor_app/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
                hintText: 'Lozinka',
                labelText: 'Lozinka',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: Config.primaryColor,
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obsecurePass = !obsecurePass;
                      });
                    },
                    icon: obsecurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Config.primaryColor,
                          ))),
          ),
          Config.spaceSmall,
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Prijavite se',
                onPressed: () async {
                  final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);

                  if (token!=null) {
                   
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final tokenValue = prefs.getString('token') ?? '';

                    if (tokenValue.isNotEmpty && tokenValue != '') {
                      final response = await DioProvider().getUser(tokenValue);
                            final user = json.decode(response);

                      final response2= await DioProvider().getAppointmentsByUser(tokenValue,user['id']);

                      final response3= await DioProvider().getAllDoctor(tokenValue);
                      final response4= await DioProvider().getFavDoctorsByUser(tokenValue, user['id']);
                      print(response4);

                      if (response != null && response2!=null && response3!=null) {
                        setState(()  {
                     
                            final appointments = json.decode(response2 );
                            final doctors = json.decode(response3 );
                            final favDocs= json.decode(response4);
                       print(favDocs);

                          auth.loginSuccess(user, appointments, doctors, favDocs);
                          MyApp.navigatorKey.currentState!.pushNamed('main');
                        });
                      }
                    }
                  } else{print("token je null");}
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}
