import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/theme_notifier.dart';
import '../../domain/usecases/auth_manager.dart';
import '../utils/app_strings.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeDocumentoController = TextEditingController();
  final _numeroDocumentoController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _obscureText = true;

  late AuthManager _authManager;

  @override
  void initState() {
    super.initState();
    _authManager = AuthManager();
  }

  void _showUserName(String buttonName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(buttonName,
          style: TextStyle(color: Colors.orange), textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.loginAlertDialogClose,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    ThemeData themeData = themeNotifier.getTheme();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/login.png',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeDocumentoController,
                      decoration: InputDecoration(
                        labelText: AppStrings.loginTypeDocument,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: themeData.appBarTheme.foregroundColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.loginTypeDocumentError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _numeroDocumentoController,
                      decoration: InputDecoration(
                        labelText: AppStrings.loginNumberDocument,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: themeData.appBarTheme.foregroundColor),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.loginNumberDocumentError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _senhaController,
                      decoration: InputDecoration(
                        labelText: AppStrings.loginPassword,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(color: themeData.appBarTheme.foregroundColor),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppStrings.loginPasswordError;
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final nomeDocumento =
                                _nomeDocumentoController.text;
                            final numeroDocumento =
                                _numeroDocumentoController.text;
                            final senha = _senhaController.text;

                            bool loginSuccess = await _authManager.login(
                                nomeDocumento, numeroDocumento, senha);
                            if (loginSuccess) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                  Text(AppStrings.invalidCredentials),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFFD58512)),
                          minimumSize: MaterialStateProperty.all<Size>(
                            Size(double.infinity, 40),
                          ),
                        ),
                        child: Text(AppStrings.loginButton),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _showUserName(AppStrings.registerUser);
                        },
                        child: Text(
                          AppStrings.registerUser,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: themeData.appBarTheme.foregroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                _showUserName(AppStrings.iconGoogle);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                      Color(0xFB0B0B0),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/google.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showUserName(AppStrings.iconFacebook);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                      Color(0xFFB0B0B0),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/facebook.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _showUserName(AppStrings.iconInstagram);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: RadialGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.9),
                      Color(0xFFB0B0B0),
                    ],
                  ),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/instagram.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
