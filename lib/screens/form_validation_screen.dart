import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// This screen demonstrates how to use RxDart's BehaviorSubject for form validation.
class FormValidationScreen extends StatefulWidget {
  const FormValidationScreen({super.key});

  @override
  _FormValidationScreenState createState() => _FormValidationScreenState();
}

class _FormValidationScreenState extends State<FormValidationScreen> {
  // BehaviorSubject is a special type of StreamController that caches the latest
  // value that has been added to the controller. When a new listener subscribes
  // to the stream, it will immediately receive the latest value.
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();

  // StreamTransformers can be used to validate the input from the streams.
  // We create a transformer for email validation.
  final StreamTransformer<String, String> _emailTransformer =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      // A simple email validation regex.
      if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError('Enter a valid email');
      }
    },
  );

  // We create a transformer for password validation.
  final StreamTransformer<String, String> _passwordTransformer =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      // A simple password validation rule.
      if (password.length >= 6) {
        sink.add(password);
      } else {
        sink.addError('Password must be at least 6 characters');
      }
    },
  );

  // We can access the transformed streams.
  Stream<String> get _emailStream =>
      _emailController.stream.transform(_emailTransformer);
  Stream<String> get _passwordStream =>
      _passwordController.stream.transform(_passwordTransformer);

  // A stream that emits true if both the email and password are valid.
  // We use combineLatest2 to combine the latest values from two streams.
  Stream<bool> get _isFormValid =>
      Rx.combineLatest2(_emailStream, _passwordStream, (e, p) => true);

  @override
  void dispose() {
    // It's important to close the controllers to avoid memory leaks.
    _emailController.close();
    _passwordController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Validation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // The email text field.
            StreamBuilder<String>(
              stream: _emailStream,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: _emailController.sink.add,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: snapshot.error as String?,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            // The password text field.
            StreamBuilder<String>(
              stream: _passwordStream,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: _passwordController.sink.add,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: snapshot.error as String?,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            // The submit button.
            // It is enabled only when the form is valid.
            StreamBuilder<bool>(
              stream: _isFormValid,
              builder: (context, snapshot) {
                return ElevatedButton(
                  onPressed: snapshot.hasData ? () {} : null,
                  child: const Text('Submit'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
