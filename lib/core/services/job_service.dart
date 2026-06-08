import 'api_client.dart';

class JobService {
  JobService._();
  static final JobService instance = JobService._();

  final _client = ApiClient.instance;

  Future<ApiResult<Map<String, dynamic>>> createJob(Map<String, dynamic> jobData) {
    return _client.post('/jobs', jobData, auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> getEmployerJobs() {
    return _client.get('/jobs/employer/mine', auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> getJobsFeed({
    String? category,
    bool? isWork,
    String? state,
    String? district,
    String? mandal,
  }) {
    final queryParams = <String>[];
    if (category != null) queryParams.add('category=$category');
    if (isWork != null) queryParams.add('isWork=$isWork');
    if (state != null) queryParams.add('state=$state');
    if (district != null) queryParams.add('district=$district');
    if (mandal != null) queryParams.add('mandal=$mandal');

    final path = queryParams.isEmpty ? '/jobs' : '/jobs?${queryParams.join('&')}';
    return _client.get(path, auth: true);
  }
}
