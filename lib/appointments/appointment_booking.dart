import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentForm extends StatefulWidget {
  final String titleTxt;
  final String hospitalName;

  const AppointmentForm({
    Key? key,
    required this.titleTxt,
    required this.hospitalName,
  }) : super(key: key);

  @override
  _AppointmentFormState createState() => _AppointmentFormState();
}

class _AppointmentFormState extends State<AppointmentForm> {
  String personName = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
        title: Text(widget.titleTxt),
    backgroundColor: Colors.cyan,
    elevation: 0,
    centerTitle: true,
    ),
    body: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    widget.hospitalName,
    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 16),
    TextField(
    decoration: InputDecoration(
    labelText: "Name",
    border: OutlineInputBorder(),
    ),
    onChanged: (value) {
    personName = value;
    },
    ),
    SizedBox(height: 16),
    InkWell(
    onTap: () => _selectDate(context),
    child: InputDecorator(
    decoration: InputDecoration(
    labelText: 'Date',
    border: OutlineInputBorder(),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
    Text(
    "${selectedDate.toLocal()}".split(' ')[0],
    style: TextStyle(fontSize: 16),
    ),
    Icon(Icons.calendar_today),
    ],
    ),
    ),
    ),
    SizedBox(height: 16),
    InkWell(
    onTap: () => _selectTime(context),
    child: InputDecorator(
    decoration: InputDecoration(
    labelText: 'Time',
    border: OutlineInputBorder(),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
    Text(
    "${selectedTime.format(context)}",
    style: TextStyle(fontSize: 16),
    ),
    Icon(Icons.access_time),
    ],
    ),
    ),
    ),
    SizedBox(height: 32),
    Center(
    child: ElevatedButton(
      onPressed: () async {
        if (personName.trim().isEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Error"),
              content: Text("Please provide a name."),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
          );
        } else {
          final appointmentRef = FirebaseFirestore.instance.collection("appointments");
          await appointmentRef.add({
            "hospitalName": widget.hospitalName,
            "serviceName": widget.titleTxt,
            "personName": personName,
            "date": selectedDate,
            "time": selectedTime.format(context),
            "status": 0,
            "email": user?.email,
            "payment": 0,
          });
          Navigator.pop(context);
        }
      },

      child: Text("Book Appointment"),
          ),
          )
          ],
      ),
    )
    );
  }
}
