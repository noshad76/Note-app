import 'package:flutter/material.dart';
import 'package:flutter_application_3/database/note_database.dart';
import 'package:lottie/lottie.dart';

import '../models/colors.dart';
import '../models/note.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  late Future<List<Note>?> notes;
  @override
  void initState() {
    refteshdb();
    super.initState();
  }

  bool isloading = false;
  @override
  void dispose() {
    NoteDatabase.instans.closeDb();
    super.dispose();
  }

  void refteshdb() async {
    setState(() {
      isloading = true;
    });
    notes = NoteDatabase.instans.readAllNotes();
    setState(() {
      isloading = false;
    });
  }

  final editformkey = GlobalKey<FormState>();
  String? title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ٔWelcome to Note'),
        backgroundColor: pink,
      ),
      body: FutureBuilder(
          future: NoteDatabase.instans.readAllNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData) {
              return Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  LottieBuilder.asset(r'assets\animation\Notthing.json'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'click',
                        style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      Icon(
                        Icons.add,
                        size: 25,
                        color: blue,
                      ),
                      Text(
                        'to add new note',
                        style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      )
                    ],
                  )
                ],
              );
            }
            return isloading
                ? CircularProgressIndicator()
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          await showModalBottomSheet(
                            showDragHandle: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            backgroundColor: black,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Container(
                                    child: editForm(
                                        snapshot.data![index].id!,
                                        snapshot.data![index].title!,
                                        snapshot.data![index].content!),
                                  );
                                },
                              );
                            },
                          );
                          refteshdb();
                        },
                        child: Card(
                          color: blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data![index].title!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(snapshot.data![index].content!),
                              const SizedBox(
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, 'addRoute');
          refteshdb();
        },
        backgroundColor: pink,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  Widget editForm(int id, String initTitle, String initDescription) {
    return Form(
      key: editformkey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: green,
                        title: const Text('Deleting'),
                        content: const Text('Are you sure to delete note?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'cancel',
                              style: TextStyle(color: black),
                            ),
                          ),
                          TextButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context);

                                await NoteDatabase.instans.deleteNote(id);

                                navigator.pop();
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(color: pink),
                              )),
                        ],
                      );
                    },
                  );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.delete),
              ),
              const Text(
                'Edit Note',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (editformkey.currentState!.validate()) {
                    await NoteDatabase.instans.editNote(Note(
                        id: id,
                        title: title ?? initTitle,
                        content: description ?? initDescription));
                    navigator.pop();
                  }
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: initTitle,
              onChanged: (value) {
                title = value;
              },
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'title should be filled';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                label: Text(
                  'Title',
                  style: TextStyle(fontWeight: FontWeight.bold, color: blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: pink, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: pink, width: 2),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: initDescription,
              onChanged: (value) {
                description = value;
              },
              onTapOutside: (event) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              maxLines: 5,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'description should be filled';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                alignLabelWithHint: true,
                label: Text(
                  'description',
                  style: TextStyle(fontWeight: FontWeight.bold, color: blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: green, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: pink, width: 2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: pink, width: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
