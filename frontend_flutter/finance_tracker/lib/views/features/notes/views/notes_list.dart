import 'package:finance_tracker/common/models/response_model.dart';
import 'package:finance_tracker/views/features/notes/models/note_model.dart';
import 'package:finance_tracker/views/features/notes/providers/note_client.dart';
import 'package:finance_tracker/views/features/notes/views/note_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteList extends StatefulWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Future<ResponseList<Note>> _notesFuture;
  final NoteApiClient _noteApiClient = NoteApiClient();
  DateTime date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _notesFuture = _noteApiClient.getNotes(month: date.month);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResponseList<Note>>(
      future: _notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}')); // Show error message
        }

        // If data is fetched successfully, build a list of user cards
        List<Note> notes = snapshot.data!.results;
        const double cardSize = 150.0;

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  iconSize: 20,
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    setState(() {
                      date = DateTime(date.year, date.month - 1, date.day);
                      _notesFuture = _noteApiClient.getNotes(month: date.month);
                    });
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(date),
                  style: const TextStyle(fontSize: 20),
                ),
                IconButton(
                  iconSize: 20,
                  icon: const Icon(
                    Icons.arrow_forward,
                  ),
                  onPressed: () {
                    setState(() {
                      date = DateTime(date.year, date.month + 1, date.day);
                      _notesFuture = _noteApiClient.getNotes(month: date.month);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            if (!snapshot.hasData || snapshot.data!.results.isEmpty)
              const Center(
                  child: Text('No notes found')) // Show message if no data
            else
              Expanded(
                child: GridView.builder(
                  itemCount: notes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        (MediaQuery.of(context).size.width / cardSize)
                            .floor(), // Number of columns in the grid
                    crossAxisSpacing: 10.0, // Spacing between columns
                    mainAxisSpacing: 10.0, // Spacing between rows
                    childAspectRatio: 1.0, // Aspect ratio of each item
                  ),
                  itemBuilder: (context, index) {
                    return NoteCard(
                      note: notes[index],
                      size: cardSize,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
