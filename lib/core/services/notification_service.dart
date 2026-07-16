import 'dart:convert';
import '../models/notification_model.dart';
import 'api_client.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient.instance;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await _apiClient.get('/notifications');

      if (response.success) {
        final data = response.data;
        if (data?['success'] == true) {
          return (data!['data'] as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList();
        }
      }
      throw Exception('Failed to load notifications');
    } catch (e) {
      print('Error fetching notifications: $e'); // TODO: Replace with logger
      return [];
    }
  }

  Future<bool> markAsRead(String id) async {
    try {
      final response = await _apiClient.patch('/notifications/$id/read', {});
      return response.success;
    } catch (e) {
      print('Error marking notification as read: $e'); // TODO: Replace with logger
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    try {
      final response = await _apiClient.patch('/notifications/read-all', {});
      return response.success;
    } catch (e) {
      print('Error marking all notifications as read: $e'); // TODO: Replace with logger
      return false;
    }
  }
}
