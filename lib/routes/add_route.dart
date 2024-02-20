import 'package:flutter/material.dart';
import 'package:flutter_application_3/database/note_database.dart';

import '../models/colors.dart';
import '../models/note.dart';

class AddRoute extends StatefulWidget {
  const AddRoute({super.key});

  @override
  State<AddRoute> createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool oncreate = false;

  void _createNote() async {
    final navigator = Navigator.of(context);
    if (formKey.currentState!.validate()) {
      String tit = title.text;
      String content = description.text;
      setState(() {
        oncreate = true;
      });
      await NoteDatabase.instans.createnote(Note(title: tit, content: content));
      setState(() {
        oncreate = false;
      });
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('ٔWelcome to Note'),
        actions: [
          IconButton(
              onPressed: () {
                _createNote();
              },
              icon: Icon(Icons.save))
        ],
        backgroundColor: pink,
      ),
      backgroundColor: black,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: title,
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
                controller: description,
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
      ),
    );
  }
}
