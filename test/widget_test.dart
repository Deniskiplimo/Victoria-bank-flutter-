import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:victoria/DashboardScreen.dart';
import 'package:victoria/LoginScreen.dart';
import 'package:victoria/SplashScreen.dart';
import 'package:victoria/main.dart';  // Import the main.dart file

void main() {
  testWidgets('Test SplashScreen and LoginScreen Navigation', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isOtpVerified: false));  // Start with SplashScreen

    // Verify that SplashScreen is shown
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);

    // Wait for the duration of the splash screen
    await tester.pumpAndSettle();

    // Verify that LoginScreen is now shown
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('Test Login and OTP Flow', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(isOtpVerified: false));  // Start with LoginScreen

    // Fill in the username and password fields
    await tester.enterText(find.byType(TextField).at(0), 'testUser');
    await tester.enterText(find.byType(TextField).at(1), 'testPassword');

    // Tap the 'Submit' button to initiate the OTP process
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the OTP field appears
    expect(find.byType(TextField).at(2), findsOneWidget);

    // Fill in the OTP field and verify OTP
    await tester.enterText(find.byType(TextField).at(2), '123456');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // After successful OTP verification, check for navigation to DashboardScreen
    expect(find.byType(LoginScreen), findsNothing);
    expect(find.byType(DashboardScreen), findsOneWidget);
  });

  testWidgets('Test DashboardScreen Display', (WidgetTester tester) async {
    // Build our app and trigger a frame with OTP verified
    await tester.pumpWidget(const MyApp(isOtpVerified: true));  // Start with DashboardScreen

    // Verify that DashboardScreen is shown
    expect(find.byType(DashboardScreen), findsOneWidget);

    // Verify that the AppBar has the correct title
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
