import 'package:finance_tracker/views/features/notes/models/note_model.dart';
import 'package:finance_tracker/views/features/notes/views/note_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final double size;

  const NoteCard({Key? key, required this.note, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailsPage(
              note: note,
            ),
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Shadow color with opacity
              blurRadius: 8, // Softness of the shadow
              spreadRadius: 2, // How far the shadow spreads
              offset:
                  const Offset(0, 4), // Shadow position, centered vertically
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                note.createdAt!.day.toString(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('EEEE').format(note.createdAt!),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
