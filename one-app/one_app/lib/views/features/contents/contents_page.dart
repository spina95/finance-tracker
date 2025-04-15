import 'package:flutter/material.dart';
import 'package:one_app/common/const.dart';
import 'package:one_app/views/features/contents/add_content_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeenContentsPage extends StatefulWidget {
  const SeenContentsPage({super.key});

  @override
  _SeenContentsPageState createState() => _SeenContentsPageState();
}

class _SeenContentsPageState extends State<SeenContentsPage> {
  final supabaseClient = Supabase.instance.client;
  final List<Map<String, dynamic>> _contents = [];
  List<Map<String, dynamic>> _types = [];
  List<Map<String, dynamic>> _statuses = [];
  int _page = 0;
  bool _isLoading = false;
  bool _hasMore = true;
  Map<String, dynamic>? _selectedStatus;
  Map<String, dynamic>? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _loadContents();
  }

  Future<void> _loadFilters() async {
    final statusResponse = await supabaseClient.from('content_status').select();
    final typeResponse = await supabaseClient.from('content_types').select();

    setState(() {
      _statuses = List<Map<String, dynamic>>.from(statusResponse);
      _types = List<Map<String, dynamic>>.from(typeResponse);
    });
  }

  Future<void> _loadContents() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    var query = supabaseClient
        .from('contents')
        .select('id, name, author, date, score, type ( * ), status ( * )');

    if (_selectedStatus != null) {
      query = query.eq('status', _selectedStatus!['id']);
    }

    if (_selectedType != null) {
      query = query.eq('type', _selectedType!['id']);
    }

    final response = await query
        .order('date', ascending: false)
        .range(_page * 10, (_page + 1) * 10 - 1);

    final List<Map<String, dynamic>> newContents =
        List<Map<String, dynamic>>.from(response);

    setState(() {
      _contents.addAll(newContents);
      _hasMore = newContents.length == 10;
      _page++;
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _onFilterChanged() {
    setState(() {
      _contents.clear();
      _page = 0;
      _hasMore = true;
    });
    _loadContents();
  }

  Widget dropDown({
    required String hint,
    Map<String, dynamic>? value,
    required Function(Map<String, dynamic>?) onChanged,
    required List<DropdownMenuItem<Map<String, dynamic>>>? items,
  }) {
    return Container(
      child: Center(
        child: DropdownButton<Map<String, dynamic>>(
          elevation: 0,
          underline: Container(color: Colors.transparent),
          hint: Text(hint),
          alignment: Alignment.center,
          value: value,
          onChanged: onChanged,
          items: items,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contents'),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadContents();
          }
          return false;
        },
        child: Stack(
          children: [
            Column(
              children: [
                // Add filters here if needed
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: 70, horizontal: 16),
                    itemCount: _contents.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 8,
                    ),
                    itemBuilder: (context, index) {
                      if (index == _contents.length) {
                        return _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Container();
                      }
                      final content = _contents[index];
                      return Container(
                        height: 90,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withAlpha(200),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  spacing: 16,
                                  children: [
                                    Text(
                                      content['type']['icon'] ?? '❓',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Column(
                                      spacing: 2,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          content['name'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        if (content['author'] != null)
                                          Text('${content['author']}'),
                                        Text('${content['date']}'),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  spacing: 8,
                                  children: [
                                    if (content['score'] != null &&
                                        content['score'] != 0)
                                      Text(
                                        '${content['score']} ⭐',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: hexToColor(
                                            content['status']['color']),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        content['status']['name']
                                            .toString()
                                            .toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black12),
                  ),
                ),
                child: _isLoading == true
                    ? null
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          dropDown(
                            hint: 'Status',
                            value: _selectedStatus,
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                _selectedStatus = newValue;
                              });
                              _onFilterChanged();
                            },
                            items: _statuses
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (status) {
                              return DropdownMenuItem<Map<String, dynamic>>(
                                value: status,
                                child: Text(
                                    status['name'].toString().capitalize()),
                              );
                            }).toList(),
                          ),
                          dropDown(
                            hint: 'Category',
                            value: _selectedType,
                            onChanged: (Map<String, dynamic>? newValue) {
                              setState(() {
                                _selectedType = newValue;
                              });
                              _onFilterChanged();
                            },
                            items: _types
                                .map<DropdownMenuItem<Map<String, dynamic>>>(
                                    (type) {
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
                          ),
                          TextButton(
                            onPressed: () {
                              _selectedStatus = null;
                              _selectedType = null;
                              _onFilterChanged();
                            },
                            child: Text(
                              "Reset",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                          )
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContentPage()),
          );
          if (result == true) {
            _onFilterChanged(); // Reload the contents if a new content was added
          }
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
