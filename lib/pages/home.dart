import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_project/pages/description.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String uid = '';

  @override
  Widget build(BuildContext context) {
    User user = auth.currentUser!;
    setState(() {
      uid = user.uid;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todos"),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('task')
                .doc(uid)
                .collection('my_tasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final docs = snapshot.data?.docs;
                return ListView.builder(
                  itemCount: docs?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DescriptionPage(
                                      title: docs?[index]['title'],
                                      description: docs?[index]['description'],
                                      time: docs?[index]['time'],
                                      uid: uid,
                                      completeness: docs?[index]
                                          ['completeness'],
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: docs?[index]['completeness']
                                  ? Colors.green
                                  : Colors.red,
                              width: 3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                    docs?[index]['title'],
                                    style: GoogleFonts.roboto(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 20),
                                  child: Text(
                                      'Deadline: ${DateFormat.yMd().format((docs?[index]['deadline'] as Timestamp).toDate())}'),
                                )
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('task')
                                    .doc(uid)
                                    .collection('my_tasks')
                                    .doc(docs?[index]['time'])
                                    .delete();
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
