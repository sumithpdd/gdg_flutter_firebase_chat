import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:devfest_flutter_firebase_chat/generated/i18n.dart';
import 'package:devfest_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:devfest_flutter_firebase_chat/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  late String _name, _email, _password;
  int _selectedIndex = 0;

  _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(children: <Widget>[
        _buildEmailTF(),
        _buildPasswordTF(),
      ]),
    );
  }

  _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(children: <Widget>[
        _buildNameTF(),
        _buildEmailTF(),
        _buildPasswordTF(),
      ]),
    );
  }

  _buildNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: 'Name', icon: Icon(Icons.person_sharp)),
        validator: (input) =>
            input!.trim().isEmpty ? 'Please enter a vaild name' : null,
        onSaved: (input) => _name = input!.trim(),
      ),
    );
  }

  _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: 'Email', icon: Icon(Icons.email_sharp)),
        validator: (input) =>
            !input!.contains('@') ? 'Please enter a vaild email' : null,
        onSaved: (input) => _email = input!,
      ),
    );
  }

  _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(
            labelText: 'Password', icon: Icon(Icons.lock_open_sharp)),
        validator: (input) =>
            input!.length < 6 ? 'Password must be atleast 6 characters' : null,
        onSaved: (input) => _password = input!,
        obscureText: true,
      ),
    );
  }

  _submit() async {
    try {
      if (_selectedIndex == 0 && _loginFormKey.currentState!.validate()) {
        _loginFormKey.currentState!.save();
        await authservice.login(_email, _password);
      } else if (_selectedIndex == 1 &&
          _signupFormKey.currentState!.validate()) {
        _signupFormKey.currentState!.save();
        await authservice.signup(_name, _email, _password);
      }
    } on PlatformException catch (error) {
      _showErrorDialog(error.message!);
    }
  }

  // _changeLanguage() async {
  //   I18n.onLocaleChanged(const Locale("da", "DK"));
  // }

  _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'))
          ],
        );
      },
    );
  }

  final AuthService authservice = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 30.0),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/devfest_uki.gif",
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        " { devfest - 2021 - chat app }",
                        style: TextStyle(
                          backgroundColor: AppConstants.hexToColor(
                              AppConstants.APP_PRIMARY_COLOR_BLACK),
                          color: AppConstants.hexToColor(
                              AppConstants.APP_PRIMARY_COLOR_LIGHT),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              margin: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //18n.of(context).welcome,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 150.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: _selectedIndex == 0
                            ? AppConstants.hexToColor(
                                AppConstants.APP_PRIMARY_COLOR)
                            : AppConstants.hexToColor(
                                AppConstants.APP_BACKGROUND_COLOR_GRAY),
                        child: Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: _selectedIndex == 0
                                  ? AppConstants.hexToColor(
                                      AppConstants.APP_PRIMARY_FONT_COLOR_WHITE)
                                  : AppConstants.hexToColor(
                                      AppConstants.APP_PRIMARY_COLOR)),
                        ),
                        onPressed: () => setState(() => _selectedIndex = 0),
                      ),
                    ),
                    SizedBox(
                      width: 150.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: _selectedIndex == 1
                            ? AppConstants.hexToColor(
                                AppConstants.APP_PRIMARY_COLOR)
                            : AppConstants.hexToColor(
                                AppConstants.APP_BACKGROUND_COLOR_GRAY),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: _selectedIndex == 1
                                  ? AppConstants.hexToColor(
                                      AppConstants.APP_PRIMARY_FONT_COLOR_WHITE)
                                  : AppConstants.hexToColor(
                                      AppConstants.APP_PRIMARY_COLOR)),
                        ),
                        onPressed: () => setState(() => _selectedIndex = 1),
                      ),
                    )
                  ],
                ),
                _selectedIndex == 0 ? _buildLoginForm() : _buildSignupForm(),
                const SizedBox(height: 20.0),
                SizedBox(
                    width: 180,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: AppConstants.hexToColor(
                          AppConstants.APP_PRIMARY_COLOR),
                      onPressed: _submit,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: AppConstants.hexToColor(
                              AppConstants.APP_PRIMARY_FONT_COLOR_WHITE),
                          fontSize: 20.0,
                        ),
                      ),
                    )),
                // SizedBox(
                //     width: 180,
                //     child: FlatButton(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10.0)),
                //       color:
                //           AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                //       onPressed: () {}, //} _changeLanguage,
                //       child: const Text(
                //         'DK',
                //         style: TextStyle(
                //           color: Colors.white,
                //           fontSize: 20.0,
                //         ),
                //       ),
                //     ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
