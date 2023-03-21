import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healmeup/Screens/Login/components/login_form.dart';
import 'package:healmeup/mainScreens/app_home_screen.dart';
import 'addsignup_test.dart';
void main() {
  group('LoginForm', () {
    testWidgets('Should login with correct email and password', (tester) async {
      final auth = MockFirebaseAuth();
      await tester.pumpWidget(MaterialApp(
        home: LoginForm(),
      ));
      await tester.enterText(find.byType(TextFormField).first, 'mayankpareek740@gmail.com');
      await tester.enterText(find.byType(TextFormField).last, 'Mayank604@');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.byType(FitnessAppHomeScreen() as Type), findsOneWidget);
    });
  });
}
