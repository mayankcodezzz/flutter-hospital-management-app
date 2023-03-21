import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healmeup/Screens/Login/login_screen.dart';
import 'package:healmeup/Screens/Welcome/components/login_signup_btn.dart';
void main() {
  testWidgets('Click Login button', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginAndSignupBtn()));
    final loginButton = find.byType(ElevatedButton).first;
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}