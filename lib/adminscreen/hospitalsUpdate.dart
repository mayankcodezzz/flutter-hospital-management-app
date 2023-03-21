import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Hospital {
  final String id;
  final String name;
  final String location;
  final List<String> services;

  Hospital({required this.id, required this.name, required this.location, required this.services});

  Map<String, dynamic> toMap() {
    return {'name': name, 'location': location, 'services': services};
  }
}


class hospitalUpdate extends StatefulWidget {
  @override
  _hospitalUpdateState createState() => _hospitalUpdateState();
}

class _hospitalUpdateState extends State<hospitalUpdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final Set<String> _selectedServices = Set<String>();

  final List<String> _services = ['Kidney', 'Liver', 'Pregnancy', 'Teeth', 'Surgery', 'Skin Care', 'Brain', 'Bones'  ];

  void _submitData() async {
    final String name = _nameController.text;
    final String location = _locationController.text;
    final List<String> services = _selectedServices.toList();

    if (name.isEmpty || location.isEmpty) return;

    final Hospital hospital = Hospital(name: name, location: location, id: '', services: services);

    await FirebaseFirestore.instance
        .collection('hospitals')
        .add(hospital.toMap());

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Hospital added!')));

    _nameController.clear();
    _locationController.clear();
    _selectedServices.clear();
  }


  void _updateData(String? id, String? name, String? location, List<String>? services) async {
    if (id == null || name == null || location == null) return;

    await FirebaseFirestore.instance
        .collection('hospitals')
        .doc(id)
        .update({'name': name, 'location': location, 'services': services});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Hospital updated!')));
  }

  void _updateServices(String id, List<String> services) async {
    await FirebaseFirestore.instance
        .collection('hospitals')
        .doc(id)
        .update({'services': services});

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Services updated!')));
  }



  void _deleteData(String id) async {
    await FirebaseFirestore.instance
        .collection('hospitals')
        .doc(id)
        .delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Hospital deleted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Hospitals'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Hospital Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16),
            Text(
              'Services',
              style: Theme.of(context).textTheme.headline6,
            ),
            Wrap(
              spacing: 8.0,
              children: _services.map((service) {
                return FilterChip(
                  label: Text(service),
                  selected: _selectedServices.contains(service),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedServices.add(service);
                      } else {
                        _selectedServices.remove(service);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitData,
              child: Text('Add Hospital'),
            ),
            SizedBox(height: 16),
            Text(
              'Hospitals',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
            SizedBox(height: 10,),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hospitals')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                List<Hospital> hospitals = snapshot.data!.docs
                    .map((doc) =>
                    Hospital(
                      id: doc.id,
                      name: doc['name'],
                      location: doc['location'],
                      services: [],
                    ))
                    .toList();

                return Expanded(
                  child: ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];

                      return Card(
                        child: ListTile(
                          title: Text(hospital.name),
                          subtitle: Text(hospital.location),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      final _nameController = TextEditingController(text: hospital.name);
                                      final _locationController =
                                      TextEditingController(text: hospital.location);
                                      final _selectedServices = Set<String>.from(hospital.services);

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text('Update Hospital'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: _nameController,
                                                  decoration:
                                                  InputDecoration(labelText: 'Hospital Name'),
                                                ),
                                                TextField(
                                                  controller: _locationController,
                                                  decoration: InputDecoration(labelText: 'Location'),
                                                ),
                                                SizedBox(height: 16),
                                                Text(
                                                  'Services',
                                                  style: Theme.of(context).textTheme.headline6,
                                                ),
                                                Wrap(
                                                  spacing: 8.0,
                                                  children: _services.map((service) {
                                                    return FilterChip(
                                                      label: Text(service),
                                                      selected: _selectedServices.contains(service),
                                                      onSelected: (selected) {
                                                        setState(() {
                                                          if (selected) {
                                                            _selectedServices.add(service);
                                                          } else {
                                                            _selectedServices.remove(service);
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _updateServices(hospital.id, _selectedServices.toList());
                                                },
                                                child: Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        AlertDialog(
                                          title: Text('Delete Hospital'),
                                          content: Text(
                                              'Are you sure you want to delete this hospital?'),
                                          actions: [
                                            TextButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: Text('Delete'),
                                              onPressed: () {
                                                _deleteData(hospital.id);
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }}
