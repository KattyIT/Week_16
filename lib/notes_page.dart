import 'package:flutter/material.dart';
import 'model/note.dart';
import 'note_repository.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final _notesRepo = NotesRepository();
  late var _notes = <Note>[];

  @override
  void initState() {
    super.initState();
    _notesRepo
        .initDB()
        .whenComplete(() => setState(() => _notes = _notesRepo.notes));
  }

  String textName = '';
  String textDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(
            _notes[i].name,
          ),
          subtitle: Text(
            _notes[i].description,
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                              builder: (context) => SimpleDialog(
                                 children: [
                                  TextField(
                                    onChanged: (value) {
                                      setState(() {
                                  textName = value;
                                      });
                                    },
                                ),
                                   TextField(
                                     onChanged: (value) {
                                       setState(() {
                                         textDescription = value;
                                       });
                                     },
                                   ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _notes[i].name = textName;
                                          _notes[i].description = textDescription;
                                        });
                                        Navigator.pop(context);
                                      }, child: Text('update'))
                                ],
                                ));
                        },
                      icon: const Icon(Icons.edit),),),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _notes.removeAt(i);
                                    });
                                  },
                                  icon: const Icon(Icons.delete))),
           ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _showDialog() => showGeneralDialog(
        context: context,
        barrierDismissible: false,
        pageBuilder: (_, __, ___) {
          final nameController = TextEditingController();
          final descController = TextEditingController();
          return AlertDialog(
            title: const Text('New note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(hintText: 'Description'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await _notesRepo.addNote(
                    Note(
                      name: nameController.text,
                      description: descController.text,
                    ),
                  );
                  setState(() {
                    _notes = _notesRepo.notes;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );
}
