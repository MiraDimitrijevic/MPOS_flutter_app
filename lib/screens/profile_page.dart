import "package:doctor_app/main.dart";
import "package:doctor_app/utils/config.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/auth_model.dart";
import "../providers/dio_provider.dart";
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 Map<String, dynamic> user={};

@override
  void initState() {
user= Provider.of<AuthModel>(context, listen: false).getUser;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: Config.primaryColor,
            child: Column(
              children:  <Widget>[
                SizedBox(
                  height: 110,
                ),
                CircleAvatar(
                  radius: 65.0,
                  backgroundImage: AssetImage('assets/${user['profile_photo_path']}'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
            "${user['name']}  ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(
                  height: 16,
                ),
                Text(
            " ${user['email']} ",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '${user['biography']}',
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            color: Colors.grey[200],
            child: Center(
              child: Card(
                margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                child: Container(
                  width: 300,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
          
                        Divider(
                          color: Colors.grey[300],
                        ),
                        
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout_outlined,
                              color: Colors.lightGreen[400],
                              size: 35,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextButton(
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                final token = prefs.getString('token') ?? '';

                                if (token.isNotEmpty && token != '') {
                                  final response =
                                      await DioProvider().logout(token);

                                  if (response == 200) {
                                  
                                    await prefs.remove('token');
                                    setState(() {
                                      MyApp.navigatorKey.currentState!
                                          .pushReplacementNamed('/');
                                    });
                                  }
                                }
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(
                                  color: Config.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
