// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_null_comparison, avoid_print, use_build_context_synchronously
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
  late List<Task> _tasks;
  late List<bool> _taskDone;

  // for saving Data
  void saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Task t = Task.fromString(taskController.text, descriptionController.text);
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    print(list);
    list.add(json.encode(t.getMap()));
    print(list);
    prefs.setString('task', json.encode(list));
    taskController.text = '';
    descriptionController.text = '';
    Navigator.of(context).pop();
    getTasks();
  }

  // for getting left tasks after computing a function 
  void getTasks() async {
    _tasks = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasks = prefs.getString('task');
    List list = (tasks == null) ? [] : json.decode(tasks);
    for (dynamic d in list) {
      _tasks.add(Task.fromMap(json.decode(d)));
    }
    print(_tasks);

    _taskDone = List.generate(_tasks.length, (index) => false);
    setState(() {});
  }

  // For updating the List of completed tasks and removing them
  void updatePendingTasksList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Task> pendingList = [];
    for (var i = 0; i < _tasks.length; i++) {
      if (!_taskDone[i]) pendingList.add(_tasks[i]);
    }

    var pendingListEncoded = List.generate(
      pendingList.length,
      (i) => json.encode(pendingList[i].getMap()),
    );

    prefs.setString('task', json.encode(pendingListEncoded));
    getTasks();
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
        title: Text(
          'Task Manager',
          style: GoogleFonts.montserrat(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            // Save all tasks
            icon: const Icon(Icons.save),
            onPressed: () => updatePendingTasksList(),
            color: Colors.white,
          ),
          // Clear all tasks
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('task', json.encode([]));

              getTasks();
            },
            color: Colors.white,
          ),
        ],
      ),
      body: (_tasks == null)
          ? Center(
              child: Text(
                'No Tasks added yet!',
                style: GoogleFonts.montserrat(),
              ),
            )
          : SingleChildScrollView(
            child: Column(
                children: _tasks
                    .map((e) => Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          padding: const EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.black, width: 0.5),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.task,
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500),
                              ),
                              Checkbox(
                                value: _taskDone[_tasks.indexOf(e)],
                                onChanged: (val) {
                                  setState(() {
                                    _taskDone[_tasks.indexOf(e)] = val!;
                                  });
                                },
                                key: GlobalKey(),
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
            context: context,
            builder: (BuildContext context) => SingleChildScrollView(
                  child: Container(
                    // height: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    width: double.infinity,
                    color: Colors.blue.shade200,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Add Task Text
                            Text(
                              'Add Task',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // Close Button
                            GestureDetector(
                              child: const Icon(Icons.close),
                              onTap: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1.2),
                        // Task
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
                            hintStyle: GoogleFonts.montserrat(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Description
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
                          child: Row(
                            children: [
                              // Reset task Button
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  child: Text(
                                    'RESET',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => taskController.text = '',
                                ),
                              ),
                              // Add task Button
                              SizedBox(
                                width: (MediaQuery.of(context).size.width / 2) -
                                    20,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Text(
                                    'ADD',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => saveData(),
                                ),
                              ),
                            ],
                          ),
                        ),
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
