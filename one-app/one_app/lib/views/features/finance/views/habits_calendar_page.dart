import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase/supabase.dart';

class HabitsPage extends StatefulWidget {
  const HabitsPage({super.key});

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<Map<String, dynamic>> _habits = [];
  List<Map<String, dynamic>> _habitTracks = [];

  final supabaseClient = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final response = await supabaseClient.from('habits').select();
    setState(() {
      _habits = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _loadHabitTracks() async {
    final response = await supabaseClient
        .from('habits_tracks')
        .select()
        .eq('date', _selectedDay.toIso8601String().split('T').first);
    setState(() {
      _habitTracks = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _toggleHabitTrack(int habitId) async {
    final existingTrack = _habitTracks
        .where(
          (track) => track['habit_id'] == habitId,
        )
        .firstOrNull;
    if (existingTrack != null) {
      await supabaseClient
          .from('habits_tracks')
          .delete()
          .eq('id', existingTrack['id']);
    } else {
      await supabaseClient.from('habits_tracks').upsert({
        'habit_id': habitId,
        'date': _selectedDay.toIso8601String().split('T').first,
      });
    }
    _loadHabitTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits Tracker'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _loadHabitTracks();
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final isTracked = _habitTracks
                    .any((track) => track['habit_id'] == habit['id']);
                return ListTile(
                  title: Text(habit['name']),
                  trailing: Checkbox(
                    value: isTracked,
                    onChanged: (value) {
                      _toggleHabitTrack(habit['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
