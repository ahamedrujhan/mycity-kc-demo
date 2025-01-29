import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _token = '';

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final Uri url = Uri.parse('https://kc.mycity.evxtest.monster/realms/my_city_dev/protocol/openid-connect/token');
    final response = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
        'client_id' : 'my_city_mobile',
        'grant_type' : 'password',
        'client_secret' : 's0rauSkqlJBCmySuL7hdrpjf68ShXuwO'
      },
    );

    if (response.statusCode == 200) {
      // print(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      setState(() {
        _token = responseData['access_token'];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful! Token: $_token')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mycity Login Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Text('Token: $_token'),
          ],
        ),
      ),
    );
  }
}