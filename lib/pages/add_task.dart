import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/pages/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool titleValidate = false;
  bool descriptionValidate = false;
  DateTime selectedDate = DateTime.now();
  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  addTask() async {
    setState((){
      titleValidate = false;
      descriptionValidate = false;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser!;`
    String uid = user.uid;
    var time = DateTime.now();
    if( titleController.text.isEmpty){
      setState((){
        titleValidate = true;
      });
    }
    if( descriptionController.text.isEmpty){
      setState((){
        descriptionValidate = true;
      });
    }
    if(!titleValidate && !descriptionValidate) {
      await FirebaseFirestore.instance
        .collection('task')
        .doc(uid)
        .collection('my_tasks')
        .doc(time.toString())
        .set({
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'time': time.toString(),
      'timestamp': time,
      'completeness': false,
      'deadline': selectedDate
    });
      Fluttertoast.showToast(msg: 'Task added');
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != selectedDate) {
      setState(() {
        selectedDate = selected!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              titleValidate
                  ? const Text('Title must not be empty!',
                      style: TextStyle(color: Colors.red, fontSize: 10))
                  : const Text(''),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter title',
                ),
                controller: titleController,
              ),
              const SizedBox(
                height: 10,
              ),
              descriptionValidate
                  ? const Text('Title must not be empty!',
                      style: TextStyle(color: Colors.red, fontSize: 10))
                  : const Text(''),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter description',
                ),
                controller: descriptionController,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: const Text("Choose deadline"),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      addTask();
                      if(!titleValidate && !descriptionValidate){
                        titleController.clear();
                        descriptionController.clear();
                      }
                      FocusScope.of(context).unfocus();
                    },
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.lightBlue;
                      }
                      return Theme.of(context).primaryColor;
                    })),
                    child: Text(
                      'Add Task',
                      style: GoogleFonts.roboto(fontSize: 18),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
