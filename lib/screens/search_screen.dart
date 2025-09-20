import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// This screen demonstrates how to use debounceTime for search functionality.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // A BehaviorSubject to hold the search query.
  final BehaviorSubject<String> _searchController = BehaviorSubject<String>();
  // A stream that will emit the search results.
  Stream<List<String>>? _searchResultsStream;

  @override
  void initState() {
    super.initState();
    // We listen to the search query stream and apply the debounceTime operator.
    // debounceTime will only emit an event after a specified duration has passed
    // without any other event being emitted. This is useful to prevent making
    // a network request for every keystroke.
    _searchResultsStream = _searchController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap((query) {
      // If the query is empty, we return an empty list of results.
      if (query.isEmpty) {
        return Stream.value([]);
      }
      // Otherwise, we perform the search.
      // In a real application, this would be a network request.
      // Here, we simulate it with a Future.delayed.
      return Stream.fromFuture(_performSearch(query));
    });
  }

  // This method simulates a network request to perform a search.
  Future<List<String>> _performSearch(String query) async {
    // Simulate a network delay.
    await Future.delayed(const Duration(seconds: 1));
    // In a real application, you would make a network request to a server.
    // For this example, we just return a list of dummy results.
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
        title: const Text('Search with debounceTime'),
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
