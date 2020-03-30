import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gdg_flutter_firebase_chat/helpers/app_constants.dart';
import 'package:gdg_flutter_firebase_chat/services/auth_service.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  String _name, _email, _password;
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
        decoration: const InputDecoration(labelText: 'Name'),
        validator: (input) =>
            input.trim().isEmpty ? 'Please enter a vaild name' : null,
        onSaved: (input) => _name = input.trim(),
      ),
    );
  }

  _buildEmailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Email'),
        validator: (input) =>
            !input.contains('@') ? 'Please enter a vaild email' : null,
        onSaved: (input) => _email = input,
      ),
    );
  }

  _buildPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Password'),
        validator: (input) =>
            input.length < 6 ? 'Password must be atleast 6 characters' : null,
        onSaved: (input) => _password = input,
        obscureText: true,
      ),
    );
  }

  _submit() async {
    try {
      if (_selectedIndex == 0 && _loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        await authservice.login(_email, _password);
      } else if (_selectedIndex == 1 &&
          _signupFormKey.currentState.validate()) {
        _signupFormKey.currentState.save();
        await authservice.signup(_name, _email, _password);
      }
    } on PlatformException catch (error) {
      _showErrorDialog(error.message);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context), child: Text('OK'))
          ],
        );
      },
    );
  }
  final AuthService authservice =  AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome!',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 0 ? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR) : Colors.grey[300],
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              _selectedIndex == 0 ? Colors.white : AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR)),
                    ),
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: _selectedIndex == 1 ? AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR) : Colors.grey[300],
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          fontSize: 20.0,
                          color:
                              _selectedIndex == 1 ? Colors.white : AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR)),
                    ),
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                )
              ],
            ),
            _selectedIndex == 0 ? _buildLoginForm() : _buildSignupForm(),
            const SizedBox(height: 20.0),
            Container(
                width: 180,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  color: AppConstants.hexToColor(AppConstants.APP_PRIMARY_COLOR),
                  onPressed: _submit,
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
