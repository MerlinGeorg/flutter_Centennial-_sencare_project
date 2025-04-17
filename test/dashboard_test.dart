// // This is a basic widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap gestures to
// // the widget. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sencare_project/screens/dashboard_screen.dart';
// import 'package:sencare_project/services/api_service.dart';

// class MockSharedPreferences extends Mock implements SharedPreferences {}

// class MockApiService extends Mock implements ApiService {}

// void main() {
//   group('DashboardScreen Widget Tests', () {
//     late MockSharedPreferences mockSharedPreferences;
//     late MockApiService mockApiService;

//     setUp(() {
//       mockSharedPreferences = MockSharedPreferences();
//       mockApiService = MockApiService();
//       // Set up shared preferences to return a default name.
//       when(mockSharedPreferences.getString('name')).thenReturn('Test User');
//     });

//     Widget makeTestableWidget({required Widget child}) {
//       return MaterialApp(
//         home: child,
//       );
//     }

//     testWidgets('DashboardScreen displays HomeScreen with user name',
//         (WidgetTester tester) async {
//       // Build our widget and trigger a frame.
//       await tester.pumpWidget(makeTestableWidget(
//           child: DashboardScreen())); // Pass the mock instance.

//       // Wait for the Future to complete and trigger a frame.
//       await tester.pumpAndSettle();

//       // Verify that the HomeScreen is displayed with the correct user name.
//       expect(find.text('Welcome Test User'), findsOneWidget);
//     });

//     testWidgets('DashboardScreen displays CircularProgressIndicator while loading',
//         (WidgetTester tester) async {
//       // Override the return to simulate a loading state.
//       when(mockSharedPreferences.getString('name')).thenReturn(null);
//       // Build our widget and trigger a frame.
//       await tester.pumpWidget(makeTestableWidget(
//           child: DashboardScreen())); // Pass the mock instance.

//       // Verify that the CircularProgressIndicator is displayed.
//       expect(find.byType(CircularProgressIndicator), findsOneWidget);
//     });
//   });

//   group('HomeScreen Widget Tests', () {
//     testWidgets('HomeScreen displays welcome message', (WidgetTester tester) async {
//       // Define a test name
//       const testName = 'Test User';

//       // Pump the HomeScreen widget
//       await tester.pumpWidget(MaterialApp(home: HomeScreen(name: testName)));

//       // Use finders to locate widgets in the UI and verify their properties
//       expect(find.text('Welcome $testName'), findsOneWidget);
//     });

//     testWidgets('HomeScreen displays the title', (WidgetTester tester) async {
//       // Setup
//       const testName = 'Test User';

//       // Execute
//       await tester.pumpWidget(MaterialApp(home: HomeScreen(name: testName)));

//       // Verify
//       expect(find.text('Welcome $testName'), findsOneWidget);
//     });
//   });
// }
