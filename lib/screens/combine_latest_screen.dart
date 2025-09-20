import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// This screen demonstrates how to use combineLatest to merge data from
// multiple streams.
class CombineLatestScreen extends StatefulWidget {
  const CombineLatestScreen({super.key});

  @override
  _CombineLatestScreenState createState() => _CombineLatestScreenState();
}

class _CombineLatestScreenState extends State<CombineLatestScreen> {
  // We'll use BehaviorSubjects to simulate two different data sources.
  // One for the user's profile.
  final BehaviorSubject<String> _profileController =
      BehaviorSubject<String>.seeded('Fetching profile...');
  // Another for the user's settings.
  final BehaviorSubject<String> _settingsController =
      BehaviorSubject<String>.seeded('Fetching settings...');

  // A stream that combines the latest values from the profile and settings streams.
  // Rx.combineLatest2 takes two streams and a combiner function. It emits a new
  // value whenever any of the source streams emit a value. The emitted value
  // is the result of the combiner function.
  Stream<String> get _combinedStream => Rx.combineLatest2(
        _profileController.stream,
        _settingsController.stream,
        (profile, settings) => 'Profile: $profile\nSettings: $settings',
      );

  @override
  void dispose() {
    _profileController.close();
    _settingsController.close();
    super.dispose();
  }

  // This method simulates fetching the user's profile.
  void _fetchProfile() {
    _profileController.add('Loading profile...');
    Future.delayed(const Duration(seconds: 2), () {
      _profileController.add('John Doe');
    });
  }

  // This method simulates fetching the user's settings.
  void _fetchSettings() {
    _settingsController.add('Loading settings...');
    Future.delayed(const Duration(seconds: 3), () {
      _settingsController.add('Dark Mode: ON');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combine Latest Streams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Buttons to trigger the data fetching.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _fetchProfile,
                  child: const Text('Fetch Profile'),
                ),
                ElevatedButton(
                  onPressed: _fetchSettings,
                  child: const Text('Fetch Settings'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // The StreamBuilder listens to the combined stream and displays the data.
            StreamBuilder<String>(
              stream: _combinedStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return Text(
                  snapshot.data ?? 'No data',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
