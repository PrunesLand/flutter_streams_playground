import 'package:flutter/material.dart';
import 'package:flutter_streams_playground/screens/basic_stream_screen.dart';
import 'package:flutter_streams_playground/screens/combine_latest_screen.dart';
import 'package:flutter_streams_playground/screens/error_handling_screen.dart';
import 'package:flutter_streams_playground/screens/form_validation_screen.dart';
import 'package:flutter_streams_playground/screens/search_screen.dart';
import 'package:flutter_streams_playground/screens/type_ahead_search_screen.dart';

// The main entry point of the application.
void main() {
  runApp(const MyApp());
}

// The root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Streams & RxDart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// The home screen of the application.
// This screen displays a list of examples that showcase different features of
// Flutter Streams and RxDart.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Streams & RxDart'),
      ),
      body: ListView(
        children: <Widget>[
          // A list tile that navigates to the Basic Stream example.
          ListTile(
            title: const Text('Basic Stream with StreamBuilder'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BasicStreamScreen(),
                ),
              );
            },
          ),
          // A list tile that navigates to the Form Validation example.
          ListTile(
            title: const Text('Form Validation with BehaviorSubject'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const FormValidationScreen(),
                ),
              );
            },
          ),
          // A list tile that navigates to the Search with debounceTime example.
          ListTile(
            title: const Text('Search with debounceTime'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
          // A list tile that navigates to the Type-ahead Search with switchMap example.
          ListTile(
            title: const Text('Type-ahead Search with switchMap'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const TypeAheadSearchScreen(),
                ),
              );
            },
          ),
          // A list tile that navigates to the Combine Latest example.
          ListTile(
            title: const Text('Combine Latest Streams'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CombineLatestScreen(),
                ),
              );
            },
          ),
          // A list tile that navigates to the Error Handling example.
          ListTile(
            title: const Text('Error Handling in Streams'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ErrorHandlingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
