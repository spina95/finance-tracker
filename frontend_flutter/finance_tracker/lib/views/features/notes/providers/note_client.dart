import 'package:finance_tracker/common/api_client.dart';
import 'package:finance_tracker/common/models/response_model.dart';
import 'package:finance_tracker/views/features/notes/models/note_model.dart';

class NoteApiClient extends ApiClient {
  NoteApiClient() : super();

  Future<ResponseList<Note>> getNotes({int? month}) async {
    try {
      final response =
          await dio.get('/personal/notes', queryParameters: {"month": month});
      return ResponseList<Note>.fromJson(
          response.data, (json) => Note.fromJson(json));
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  Future<Note> getById(int id) async {
    try {
      final response = await dio.get('/personal/notes/$id/');
      return Note.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user');
    }
  }

  Future<Note> create(Note note) async {
    try {
      final response = await dio.post('/personal/notes/', data: note.toJson());
      return Note.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }

  Future<Note> update(Note note) async {
    try {
      final response =
          await dio.put('/personal/notes/${note.id}/', data: note.toJson());
      return Note.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user');
    }
  }
}
