import 'api_client.dart';
import '../models/worker_filter_model.dart';

class WorkerService {
  WorkerService._();
  static final WorkerService instance = WorkerService._();

  final _client = ApiClient.instance;

  Future<ApiResult<Map<String, dynamic>>> getWorkers({
    String? search,
    WorkerFilterModel? filter,
  }) {
    final queryParams = <String>[];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    
    if (filter != null) {
      if (filter.category != null) queryParams.add('category=${filter.category}');
      if (filter.occupation != null) queryParams.add('occupation=${filter.customOccupation ?? filter.occupation}');
      if (filter.experience != null) queryParams.add('experienceLevel=${filter.experience}');
      if (filter.workType != null) queryParams.add('workType=${filter.workType}');
      if (filter.availability != null) queryParams.add('availability=${filter.availability}');
      if (filter.location != null) {
        if (filter.location!['state'] != null) queryParams.add('state=${filter.location!['state']}');
        if (filter.location!['district'] != null) queryParams.add('district=${filter.location!['district']}');
        if (filter.location!['mandal'] != null) queryParams.add('mandal=${filter.location!['mandal']}');
      }
    }

    final path = queryParams.isEmpty ? '/workers' : '/workers?${queryParams.join('&')}';
    return _client.get(path, auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> getWorkerById(String profileId) {
    return _client.get('/workers/$profileId', auth: true);
  }
}
