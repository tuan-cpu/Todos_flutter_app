import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionPage extends StatelessWidget {
  final String title, description, time, uid;
  final bool completeness;

  const DescriptionPage(
      {Key? key,
      required this.title,
      required this.description,
      required this.time,
      required this.uid,
      required this.completeness})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var doc = FirebaseFirestore.instance
        .collection('task')
        .doc(uid)
        .collection('my_tasks')
        .doc(time);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              description,
              style: GoogleFonts.roboto(fontSize: 18),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: completeness ? Colors.red : Colors.green,
        onPressed: () {
          doc.update({'completeness': !completeness}).then(
              (value) => Navigator.pop(context));
        },
        child:
            completeness ? const Icon(Icons.cancel) : const Icon(Icons.check),
      ),
    );
  }
}
