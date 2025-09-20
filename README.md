# Flutter Streams & RxDart Playground

This Flutter application serves as a practical guide and educational resource for understanding and implementing various features of Flutter Streams and the RxDart library. It is designed for developers, especially those preparing for senior roles, who want to deepen their knowledge of reactive programming in Flutter.

The application is structured as a series of distinct examples, each on its own screen, to provide clear and isolated demonstrations of key concepts.

## Features Demonstrated

This project provides hands-on examples of the following concepts:

-   **Basic Stream with `StreamBuilder`**: Learn the fundamentals of using `StreamController` to create a stream and `StreamBuilder` to listen to it and update the UI in real-time.

-   **Form Validation with `BehaviorSubject`**: Discover how to use RxDart's `BehaviorSubject` for efficient and reactive form validation. This example includes validating email and password fields and enabling a submit button based on the form's validity.

-   **Search with `debounceTime`**: Understand how to implement a search functionality that prevents excessive network requests for every keystroke by using the `debounceTime` operator from RxDart.

-   **Type-ahead Search with `switchMap`**: Explore a more advanced search scenario using the `switchMap` operator. This example shows how to cancel previous, outdated search requests as the user types, ensuring that only the results for the latest query are processed.

-   **Combining Streams with `combineLatest`**: See how to merge data from multiple streams into a single stream using `Rx.combineLatest`. This is useful for scenarios where the UI needs to display data from different sources, such as a user's profile and their settings.

-   **Error Handling in Streams**: Learn how to gracefully handle errors that may occur in a stream. This example demonstrates how to add errors to a stream and how to catch and display them in the UI using `StreamBuilder`, as well as how to handle them programmatically with an `onError` callback.

## Getting Started

To run this project, you will need to have Flutter installed.

1.  Clone the repository.
2.  Navigate to the project directory and run `flutter pub get` to install the dependencies.
3.  Run the application using `flutter run`.
