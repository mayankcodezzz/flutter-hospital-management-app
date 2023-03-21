import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healmeup/adminscreen/hospitalsUpdate.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('hospitalUpdate', () {
    late Widget testWidget;
    late FirebaseFirestore firestore;
    setUp(() async {
      firestore = FirebaseFirestore.instance;
      await firestore.clearPersistence();
      await firestore.collection('hospitals').get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
      testWidget = MaterialApp(home: hospitalUpdate());
    });
    testWidgets('adds a hospital to Firestore', (WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.enterText(find.byType(TextField).first, 'Isha Hospital');
      await tester.enterText(find.byType(TextField).at(1), 'Surat');
      await tester.tap(find.widgetWithText(FilterChip, 'Bones'));
      await tester.tap(find.widgetWithText(FilterChip, 'Kidney'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Add Hospital'));
      await tester.pumpAndSettle();
      expect(find.text('Hospital added!'), findsOneWidget);
      await firestore
          .collection('hospitals')
          .where('name', isEqualTo: 'Isha Hospital')
          .get()
          .then((snapshot) {
        expect(snapshot.size, 1);
        final data = snapshot.docs.first.data();
        expect(data['location'], 'Surat');
        expect(data['services'], ['Bones', 'Kidney']);
      });
    });
    testWidgets('updates a hospital in Firestore', (WidgetTester tester) async {
      final docRef = await firestore.collection('hospitals').add({
        'name': 'Isha Hospital',
        'location': 'Surat',
        'services': ['Bones'],
      });
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.edit));
      await tester.enterText(find.byType(TextField).first, 'Isha Hospital Updated');
      await tester.enterText(find.byType(TextField).at(1), 'Surat Updated');
      await tester.tap(find.widgetWithText(FilterChip, 'Kidney'));
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
      await tester.pumpAndSettle();
      expect(find.text('Hospital updated!'), findsOneWidget);
      await firestore.collection('hospitals').doc(docRef.id).get().then((doc) {
        expect(doc['name'], 'Isha Hospital Updated');
        expect(doc['location'], 'Surat Updated');
        expect(doc['services'], ['Bones', 'Kidney']);
      });
    });
    testWidgets('deletes a hospital from Firestore', (WidgetTester tester) async {
      final docRef = await firestore.collection('hospitals').add({
        'name': 'Isha Hospital',
        'location': 'Surat',
        'services': ['Bones'],
      });
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();
      expect(find.text('Hospital deleted!'), findsOneWidget);
      await firestore.collection('hospitals').doc(docRef.id).get().then((doc) {
        expect(doc.exists, false);
      });
    });
  });
}
