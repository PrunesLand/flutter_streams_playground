import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// This screen demonstrates the use of switchMap for a type-ahead search.
class TypeAheadSearchScreen extends StatefulWidget {
  const TypeAheadSearchScreen({super.key});

  @override
  _TypeAheadSearchScreenState createState() => _TypeAheadSearchScreenState();
}

class _TypeAheadSearchScreenState extends State<TypeAheadSearchScreen> {
  // A BehaviorSubject to hold the search query.
  final BehaviorSubject<String> _searchController = BehaviorSubject<String>();
  // A stream that will emit the search results.
  Stream<List<String>>? _searchResultsStream;

  @override
  void initState() {
    super.initState();
    // We use switchMap to handle the search.
    // switchMap is similar to flatMap, but it will cancel the previous inner
    // stream subscription when a new event arrives on the source stream.
    // This is perfect for type-ahead search, as it ensures that we only get
    // results for the latest query, and we don't waste resources on
    // outdated requests.
    _searchResultsStream = _searchController.stream
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap((query) {
      if (query.isEmpty) {
        return Stream.value([]);
      }
      // We return a stream that emits the search results.
      // If a new query comes in, switchMap will unsubscribe from the previous
      // stream (cancelling the search request) and subscribe to the new one.
      return Stream.fromFuture(_performSearch(query));
    });
  }

  // This method simulates a network request to perform a search.
  Future<List<String>> _performSearch(String query) async {
    // Simulate a network delay.
    await Future.delayed(const Duration(seconds: 1));
    // Check if the widget is still mounted before returning the result.
    // This is a good practice to avoid calling setState on a disposed widget.
    if (!mounted) return [];
    // Return a list of dummy results.
    return List.generate(5, (index) => 'Result for "$query" #${index + 1}');
  }

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Type-ahead with switchMap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // The search text field.
            TextField(
              onChanged: _searchController.sink.add,
              decoration: const InputDecoration(
                labelText: 'Search',
                hintText: 'Enter a search term',
              ),
            ),
            const SizedBox(height: 16),
            // The search results.
            Expanded(
              child: StreamBuilder<List<String>>(
                stream: _searchResultsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      _searchController.value.isNotEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No results found'));
                  }
                  final results = snapshot.data!;
                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(results[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
