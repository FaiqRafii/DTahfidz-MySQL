import 'package:flutter/material.dart';
import 'package:project_uas/model/userModel.dart';
import 'package:project_uas/viewmodel/loginViewModel.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;
  bool _rememberMe = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)?.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade100),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 40),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.green.shade100,
                        child: Text(
                          user!.nama.isNotEmpty
                              ? user!.nama[0].toUpperCase()
                              : '',
                          style: TextStyle(
                            fontSize: 35,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        user.nama,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${user.level[0].toUpperCase()}${user.level.substring(1).toLowerCase()}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.green.shade700,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/password', arguments: user);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.key, color: Colors.green.shade700),
                              Text(
                                'Ganti Password',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),

                          Icon(Icons.arrow_forward_ios_rounded, size: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    LoginViewModel viewModel = LoginViewModel();
    User? user = await viewModel.login(email, password);

    if (user != null) {
      Navigator.pushNamed(context, '/home', arguments: user);
    } else {
      setState(() {
        errorMessage = 'Email atau password salah';
      });
    }
  }
}
