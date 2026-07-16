import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/worker_filter_model.dart';
import '../models/job_filter_model.dart';

class FilterStorageService {
  FilterStorageService._();
  static final FilterStorageService instance = FilterStorageService._();

  static const String _workerFilterKey = 'worker_filter_prefs';
  static const String _jobFilterKey = 'job_filter_prefs';

  Future<void> saveWorkerFilter(WorkerFilterModel filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_workerFilterKey, jsonEncode(filter.toJson()));
  }

  Future<WorkerFilterModel> getWorkerFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_workerFilterKey);
    if (data != null) {
      try {
        return WorkerFilterModel.fromJson(jsonDecode(data));
      } catch (e) {
        return WorkerFilterModel(); // Return defaults on error
      }
    }
    return WorkerFilterModel();
  }

  Future<void> clearWorkerFilter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_workerFilterKey);
  }

  Future<void> saveJobFilter(JobFilterModel filter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_jobFilterKey, jsonEncode(filter.toJson()));
  }

  Future<JobFilterModel> getJobFilter() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_jobFilterKey);
    if (data != null) {
      try {
        return JobFilterModel.fromJson(jsonDecode(data));
      } catch (e) {
        return JobFilterModel(); // Return defaults on error
      }
    }
    return JobFilterModel();
  }

  Future<void> clearJobFilter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_jobFilterKey);
  }
}
