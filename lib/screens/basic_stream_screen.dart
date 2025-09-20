import 'dart:async';
import 'package:flutter/material.dart';

// This screen demonstrates the use of a basic Stream with a StreamBuilder.
class BasicStreamScreen extends StatefulWidget {
  const BasicStreamScreen({super.key});

  @override
  _BasicStreamScreenState createState() => _BasicStreamScreenState();
}

class _BasicStreamScreenState extends State<BasicStreamScreen> {
  // A StreamController is used to create and manage a stream.
  // We specify the type of data that the stream will carry, in this case, an integer.
  final StreamController<int> _streamController = StreamController<int>();
  int _counter = 0;

  @override
  void dispose() {
    // It is crucial to close the StreamController when the widget is disposed
    // to prevent memory leaks.
    _streamController.close();
    super.dispose();
  }

  // This method increments the counter and adds the new value to the stream.
  void _incrementCounter() {
    _counter++;
    // The sink property of the StreamController is used to add data to the stream.
    _streamController.sink.add(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Stream'),
      ),
      body: Center(
        // The StreamBuilder widget rebuilds itself every time a new event is
        // emitted on the stream it is listening to.
        child: StreamBuilder<int>(
          // The stream property specifies the stream that the StreamBuilder should listen to.
          stream: _streamController.stream,
          // The initialData is the data that will be used in the first build,
          // before the stream has emitted any events.
          initialData: 0,
          // The builder function is called every time a new event is emitted.
          // It provides the BuildContext and an AsyncSnapshot, which contains
          // the latest event from the stream.
          builder: (context, snapshot) {
            // The snapshot contains the data from the stream.
            // We can check the connection state to see if the stream is active,
            // done, or has an error.
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('Not connected to the stream');
              case ConnectionState.waiting:
                return const Text('Awaiting for the stream to start...');
              case ConnectionState.active:
                // When the stream is active, we display the data.
                return Text(
                  'Button pushed ${snapshot.data} times',
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              case ConnectionState.done:
                return const Text('Stream is done');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
