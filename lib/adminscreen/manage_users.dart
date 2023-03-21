import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AppointmentsPage extends StatefulWidget {
  final String hospitalName;
  final String serviceName;

  const AppointmentsPage({
    Key? key,
    required this.hospitalName,
    required this.serviceName,
  }) : super(key: key);

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.hospitalName} - ${widget.serviceName} Appointments'),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('appointments')
            .where('hospitalName', isEqualTo: widget.hospitalName)
            .where('serviceName', isEqualTo: widget.serviceName)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              bool isDone = data['status'] == 1;
              return CheckboxListTile(
                onChanged: (bool? value) async {
                  if (value != null) {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('appointments')
                          .doc(doc.id)
                          .update({'status': value ? 1 : 0});
                    });
                    if (value) {
                      final Email email = Email(
                        body:
                        'Appointment confirmed for ${data['serviceName']} on ${data['time']}.\n\nHospital: ${data['hospitalName']}\nName: ${data['personName']}\nDate: ${(data['date'] as Timestamp).toDate().toString().substring(0, 10)}',
                        subject: 'Appointment Confirmation',
                        recipients: [data['email']],
                        isHTML: false,
                      );
                      await FlutterEmailSender.send(email);
                    }
                  }
                },

                value: isDone,
                title: Text(data['personName']),
                subtitle: Text('${data['time']}\n${(data['date'] as Timestamp).toDate().toString().substring(0, 10)}'),
                secondary: Icon(isDone ? Icons.done : null),
                controlAffinity: ListTileControlAffinity.trailing,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}