import 'api_client.dart';

class WorkerService {
  WorkerService._();
  static final WorkerService instance = WorkerService._();

  final _client = ApiClient.instance;

  Future<ApiResult<Map<String, dynamic>>> getWorkers({
    String? search,
    String? skill,
    String? experienceLevel,
    double? minRating,
  }) {
    final queryParams = <String>[];
    if (search != null && search.isNotEmpty) queryParams.add('search=$search');
    if (skill != null && skill.isNotEmpty) queryParams.add('skill=$skill');
    if (experienceLevel != null && experienceLevel != 'All') {
      queryParams.add('experienceLevel=$experienceLevel');
    }
    if (minRating != null) queryParams.add('minRating=$minRating');

    final path = queryParams.isEmpty ? '/workers' : '/workers?${queryParams.join('&')}';
    return _client.get(path, auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> getWorkerById(String profileId) {
    return _client.get('/workers/$profileId', auth: true);
  }
}
