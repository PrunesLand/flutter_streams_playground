import 'dart:async';
import 'package:flutter/material.dart';

// This screen demonstrates how to handle errors in a stream.
class ErrorHandlingScreen extends StatefulWidget {
  const ErrorHandlingScreen({super.key});

  @override
  _ErrorHandlingScreenState createState() => _ErrorHandlingScreenState();
}

class _ErrorHandlingScreenState extends State<ErrorHandlingScreen> {
  // A StreamController to manage the stream.
  final StreamController<String> _streamController =
      StreamController<String>.broadcast();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // We can listen to the stream and provide an onError callback to handle
    // any errors that are added to the stream.
    _subscription = _streamController.stream.listen(
      (data) {
        // This is called when new data is added to the stream.
        print('Data: $data');
      },
      onError: (error) {
        // This is called when an error is added to the stream.
        print('Error: $error');
        // Here you could, for example, log the error to a service.
      },
      onDone: () {
        // This is called when the stream is closed.
        print('Stream is done');
      },
    );
  }

  @override
  void dispose() {
    // It's important to cancel the subscription and close the controller.
    _subscription?.cancel();
    _streamController.close();
    super.dispose();
  }

  // This method adds data to the stream.
  void _addData() {
    _streamController.sink.add('Hello from the stream!');
  }

  // This method adds an error to the stream.
  void _addError() {
    _streamController.sink.addError('Something went wrong!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling in Streams'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Buttons to add data and errors to the stream.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addData,
                  child: const Text('Add Data'),
                ),
                ElevatedButton(
                  onPressed: _addError,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Add Error'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // The StreamBuilder listens to the stream and displays the data or error.
            StreamBuilder<String>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                // The snapshot.hasError property is true if the latest event was an error.
                if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 24),
                    textAlign: TextAlign.center,
                  );
                }
                if (snapshot.hasData) {
                  return Text(
                    'Data: ${snapshot.data}',
                    style: const TextStyle(color: Colors.green, fontSize: 24),
                    textAlign: TextAlign.center,
                  );
                }
                return const Text(
                  'Press a button to start',
                  style: TextStyle(fontSize: 24),
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
