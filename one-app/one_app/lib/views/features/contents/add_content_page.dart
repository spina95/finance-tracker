import 'package:flutter/material.dart';
import 'package:one_app/common/const.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddContentPage extends StatefulWidget {
  const AddContentPage({super.key});

  @override
  _AddContentPageState createState() => _AddContentPageState();
}

class _AddContentPageState extends State<AddContentPage> {
  final supabaseClient = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  double _score = 0.0;
  Map<String, dynamic>? _selectedType;
  Map<String, dynamic>? _selectedStatus;
  List<Map<String, dynamic>> _types = [];
  List<Map<String, dynamic>> _statuses = [];

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final statusResponse = await supabaseClient.from('content_status').select();
    final typeResponse = await supabaseClient.from('content_types').select();

    setState(() {
      _statuses = List<Map<String, dynamic>>.from(statusResponse);
      _types = List<Map<String, dynamic>>.from(typeResponse);
    });
  }

  Future<void> _addContent() async {
    try {
      if (_formKey.currentState!.validate()) {
        final response = await supabaseClient.from('contents').insert({
          'name': _titleController.text,
          'author': _authorController.text,
          'score': _score,
          'type': _selectedType!['id'],
          'status': _selectedStatus!['id'],
          'date': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Content added successfully"),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: const InputDecoration(labelText: 'Type'),
                value: _selectedType,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                elevation: 2,
                items:
                    _types.map<DropdownMenuItem<Map<String, dynamic>>>((type) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: type,
                    child: Row(
                      children: [
                        Text(type['icon']),
                        Text(type['name'].toString().capitalize()),
                      ],
                    ),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: const InputDecoration(labelText: 'Status'),
                value: _selectedStatus,
                onChanged: (Map<String, dynamic>? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                },
                items: _statuses
                    .map<DropdownMenuItem<Map<String, dynamic>>>((status) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: status,
                    child: Text(status['name'].toString().capitalize()),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a status';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Score', style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _score,
                onChanged: (double value) {
                  setState(() {
                    _score = value;
                  });
                },
                min: 0,
                max: 10,
                divisions: 100,
                label: _score.toStringAsFixed(1).toString(),
              ),
              ElevatedButton(
                onPressed: _addContent,
                child: const Text('Add Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
