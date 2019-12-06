import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _LoginPageState();

}

enum FormType {
  login,
  signUp
}

class _LoginPageState extends State<LoginPage> {

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateLogin(){
    final form = formKey.currentState;
    if (form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void submitLogin() async {
    if (validateLogin()){
      try{
        if (_formType == FormType.login){
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
        } else {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        }
      } catch (e) {
        //TODO: identify and throw correct error message
      }
    }
  }

  void signUpUser() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.signUp;
    });
  }

  void backToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build (BuildContext context){
    return new Scaffold(
      appBar: new AppBar(title: new Text('Login')),
      body: new Container(
        padding: EdgeInsets.all(32.0),
        child: new Form(
          child: new Column(
            children: buildInputFields() + buildLoginSignUpButtons(),
          )
        )
      )
    );
  }

  List<Widget> buildInputFields(){
    return [
      new TextFormField(
        key: formKey,
        decoration: new InputDecoration(labelText: 'Email:'),
        validator: (value) => value.isEmpty ? 'Please enter an email' : null,
        onSaved: (value) => _email = value
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password:'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Incorrect password' : null,
        onSaved: (value) => _password = value
      ),
    ];
  }

  List<Widget> buildLoginSignUpButtons(){
    if (_formType == FormType.login){
      return [
        new RaisedButton(
          child: new Text('Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: submitLogin,
        ),
        new FlatButton(
          child: new Text('Sign Up', style: new TextStyle(fontSize: 20.0)),
          onPressed: signUpUser,
        ),
      ];
    } else {
      return [
        new RaisedButton(
          child: new Text('Create Account', style: new TextStyle(fontSize: 20.0)),
          onPressed: submitLogin,
        ),
        new FlatButton(
          child: new Text('Back to login', style: new TextStyle(fontSize: 20.0)),
          onPressed: backToLogin,
        ),
      ];
    }
  }

}

