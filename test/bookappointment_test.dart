import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healmeup/appointments/appointment_booking.dart';
import 'package:mockito/mockito.dart';


class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late AppointmentForm appointmentForm;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();

    when(mockFirebaseAuth.currentUser).thenReturn(MockUser());


    appointmentForm = AppointmentForm(
      titleTxt: 'Appointment Title',
      hospitalName: 'Hospital Name',
    );
  });

  testWidgets('AppointmentForm adds appointment with default values',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: appointmentForm));

        final nameTextField = find.widgetWithText(TextField, 'Name');
        await tester.enterText(nameTextField, 'Vishnu patel');

        final bookButton = find.widgetWithText(ElevatedButton, 'Book Appointment');
        await tester.tap(bookButton);

        verify(mockFirebaseAuth.currentUser);
        verify(mockFirebaseFirestore.collection('appointments').add({
          'hospitalName': 'Hospital Name',
          'serviceName': 'Appointment Title',
          'personName': 'Vishnu patel',
          'date': DateTime.parse('2023-12-06 00:00:00.000'),
          'time': '12:23 PM',
          'status': 0,
          'email': null,
        }));
      });
}
