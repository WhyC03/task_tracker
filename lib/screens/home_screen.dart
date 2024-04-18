// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_tracker/model/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var taskController;
  var descriptionController;
  var _tasks;

  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(taskController.text, descriptionController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ?[] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    taskController.text = '';
    descriptionController.text = '';
    Navigator.of(context).pop();
  }

  void getTasks()async{
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ?[] : json.decode(tasks);
    for(dynamic d in list){
      _tasks.add(Task.fromMap(d));
    }
    print(_tasks);
  }

  @override
  void initState() {
    super.initState();
    taskController = TextEditingController();
    descriptionController = TextEditingController();

    getTasks();
  }

  @override
  void dispose() {
    taskController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Task Manager',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Center(
        child: Text(
          'No Tasks added yet!',
          style: GoogleFonts.poppins(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                // height: 200,
                width: double.infinity,
                color: Colors.blue.shade200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add Task',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(Icons.close),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1.2),
                    const SizedBox(height: 20),
                    TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter Task',
                        hintStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: descriptionController,
                      maxLines: 7,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Description',
                        hintStyle: GoogleFonts.poppins(),

                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      width: MediaQuery.of(context).size.width,
                      // height: 200.0,
                      child: Row(
                        children: [
                          SizedBox(
                            width:
                            (MediaQuery.of(context).size.width / 2) - 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white
                              ),
                              child: Text(
                                'RESET',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () => taskController.text = '',
                            ),
                          ),
                          SizedBox(
                            width:
                            (MediaQuery.of(context).size.width / 2) - 20,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue
                              ),
                              child: Text(
                                'ADD',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () => saveData(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
        backgroundColor: Colors.blue.shade700,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
