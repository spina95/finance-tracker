import 'package:finance_tracker/common/api_client.dart';
import 'package:finance_tracker/common/models/response_model.dart';
import 'package:finance_tracker/views/features/notes/models/habit_model.dart';

class HabitApiClient extends ApiClient {
  HabitApiClient() : super();

  Future<ResponseList<Habit>> getHabits({int? month}) async {
    try {
      final response =
          await dio.get('/personal/habits', queryParameters: {"month": month});
      return ResponseList<Habit>.fromJson(
          response.data, (json) => Habit.fromJson(json));
    } catch (e) {
      throw Exception('Failed to load users');
    }
  }

  Future<Habit> getById(int id) async {
    try {
      final response = await dio.get('/personal/habits/$id/');
      return Habit.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user');
    }
  }

  Future<Habit> create(Habit habit) async {
    try {
      final response =
          await dio.post('/personal/habits/', data: habit.toJson());
      return Habit.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }

  Future<Habit> update(Habit habit) async {
    try {
      final response =
          await dio.put('/personal/habits/${habit.id}/', data: habit.toJson());
      return Habit.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user');
    }
  }
}
