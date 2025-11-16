import 'package:flutter/material.dart';
import 'package:project_uas/model/userModel.dart';
import 'package:project_uas/viewmodel/loginViewModel.dart';
import 'package:project_uas/viewmodel/userViewModel.dart';

class Password extends StatefulWidget {
  const Password({super.key});

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isObscured = true;
  bool isLoading = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final User user = ModalRoute.of(context)?.settings.arguments as User;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey.shade100),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 60, top: 20),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Column(
                children: [
                  Text(
                    "Ganti Password",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Masukkan password baru dan konfirmasi",
                    style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      spacing: 20,
                      children: [
                        TextField(
                          cursorColor: Colors.black,
                          controller: _newPasswordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                            ),
                            hintText: 'Masukkan Password Baru',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          cursorColor: Colors.black,
                          controller: _confirmPasswordController,
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscured = !_isObscured;
                                });
                              },
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                            ),
                            hintText: 'Konfirmasi Password Baru',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                              ),
                            ),
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              )
                            : Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_newPasswordController.value.text !=
                              _confirmPasswordController.value.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Password Konfirmasi Tidak Sama Dengan Password Baru",
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });

                            final response = await UserViewModel()
                                .changePassword(
                                  user.id_user,
                                  _newPasswordController.value.text,
                                );

                            setState(() {
                              isLoading = false;
                            });

                            if (response) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Berhasil Merubah Password"),
                                ),
                              );
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                              });
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
