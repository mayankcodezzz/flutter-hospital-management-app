import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healmeup/Screens/Signup/components/signup_form.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
void main() {
  group('SignUpForm widget', () {
    late MockFirebaseAuth mockFirebaseAuth;
    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
    });
    testWidgets('should sign up with email and password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignUpForm(),
          ),
        ),
      );
      final emailField = find.widgetWithText(TextFormField, 'Your email');
      final passwordField = find.widgetWithText(TextFormField, 'Your password');
      final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up'.toUpperCase());
      await tester.enterText(emailField, 'mayankpareek@gmail.com');
      await tester.enterText(passwordField, 'Mayank604@');
      await tester.tap(signUpButton);
      await tester.pump();
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'mayankpareek@gmail.com',
        password: 'Mayank604@',
      )).called(1);
    });
  });
}
