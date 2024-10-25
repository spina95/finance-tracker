import 'package:finance_tracker/views/features/notes/models/habit_model.dart';
import 'package:finance_tracker/views/features/notes/models/note_model.dart';
import 'package:finance_tracker/views/features/notes/providers/habit_client.dart';
import 'package:finance_tracker/views/features/notes/providers/note_client.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetailsPage extends StatefulWidget {
  final Note? note;

  const NoteDetailsPage({Key? key, this.note}) : super(key: key);

  @override
  _NoteDetailsPageState createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  bool isLoading = false;
  late TextEditingController _titleController;
  late TextEditingController _textController;
  Note? editedNote;
  final NoteApiClient _noteApiClient = NoteApiClient();
  final HabitApiClient _habitApiClient = HabitApiClient();
  final emoticons = [
    "😀",
    "😡",
    "😍",
    "😎",
    "🥵",
    "😵",
  ];
  String selectedEmoticon = "";
  List<Habit> habitsList = [];
  List<Habit> selectedHabitsList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _textController = TextEditingController(text: widget.note!.text);
      editedNote = widget.note!;
      Future.wait([getHabits()]).then((value) => setState(() {
            isLoading = false;
          }));
    } else {
      _titleController = TextEditingController();
      _textController = TextEditingController();
      Future.wait([getHabits(), createNote()]).then((value) => setState(() {
            isLoading = false;
          }));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> getHabits() async {
    final habits = await _habitApiClient.getHabits();
    setState(() {
      habitsList = habits.results;
    });
  }

  Future<Note> createNote() async {
    Note newNote = Note(title: "", text: "");
    Note note = await NoteApiClient().create(newNote);
    setState(() {
      editedNote = note;
    });
    return note;
  }

  String formatDate(DateTime date) {
    return DateFormat('EEEE, dd MMM yyyy').format(date);
  }

  Widget title(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              editedNote != null ? formatDate(editedNote!.createdAt!) : "",
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              setState(() {
                editedNote!.title = _titleController.text;
                editedNote!.text = _textController.text;
              });
              await _noteApiClient.update(editedNote!);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note Saved')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  title("How did you feel?"),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 32,
                    runSpacing: 0,
                    children: emoticons
                        .map(
                          (e) => InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  color: editedNote!.status == e
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                      : Colors.transparent,
                                  shape: BoxShape.circle),
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                            onTap: () {
                              setState(
                                () {
                                  editedNote!.status = e;
                                },
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  title("Habits"),
                  const SizedBox(
                    height: 16,
                  ),
                  Wrap(
                    spacing: 32,
                    runSpacing: 0,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.start,
                    children: habitsList
                        .map(
                          (e) => InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Container(
                              height: 90,
                              width: 100,
                              padding: const EdgeInsets.all(8.0),
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: selectedHabitsList.contains(e)
                                      ? Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    e.icon,
                                    style: const TextStyle(fontSize: 30),
                                  ),
                                  Text(e.name)
                                ],
                              ),
                            ),
                            onTap: () {
                              if (selectedHabitsList.contains(e)) {
                                setState(() {
                                  selectedHabitsList.remove(e);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Habit removed')),
                                );
                              } else {
                                setState(() {
                                  selectedHabitsList.add(e);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Habit added')),
                                );
                              }
                            },
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 16),
                  title("Journal"),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        border: InputBorder.none, // No border
                        hintText: '', // No label or hint text
                      ),
                      maxLines: null, // Makes the text field multiline
                      scrollPhysics: NeverScrollableScrollPhysics(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
