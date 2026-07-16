import 'api_client.dart';
import '../models/job_filter_model.dart';
import '../models/worker_filter_model.dart';

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
    bool? isWork,
    String? state,
    String? district,
    String? mandal,
    JobFilterModel? jobFilter,
    WorkerFilterModel? workerFilter,
  }) {
    final queryParams = <String>[];
    if (isWork != null) queryParams.add('isWork=$isWork');
    if (state != null) queryParams.add('state=$state');
    if (district != null) queryParams.add('district=$district');
    if (mandal != null) queryParams.add('mandal=$mandal');
    
    if (jobFilter != null) {
      if (jobFilter.jobCategory != null) queryParams.add('category=${jobFilter.jobCategory}');
      if (jobFilter.jobRole != null) queryParams.add('jobRole=${jobFilter.customJobRole ?? jobFilter.jobRole}');
      if (jobFilter.specialization != null) queryParams.add('specialization=${jobFilter.customSpecialization ?? jobFilter.specialization}');
      if (jobFilter.employmentType != null) queryParams.add('employmentType=${jobFilter.employmentType}');
      if (jobFilter.salaryType != null) queryParams.add('salaryType=${jobFilter.salaryType}');
      if (jobFilter.experience != null) queryParams.add('experience=${jobFilter.experience}');
      if (jobFilter.location != null) {
        if (jobFilter.location!['state'] != null) queryParams.add('state=${jobFilter.location!['state']}');
        if (jobFilter.location!['district'] != null) queryParams.add('district=${jobFilter.location!['district']}');
        if (jobFilter.location!['mandal'] != null) queryParams.add('mandal=${jobFilter.location!['mandal']}');
      }
    }
    
    if (workerFilter != null) {
      if (workerFilter.category != null) queryParams.add('category=${workerFilter.category}');
      if (workerFilter.occupation != null) queryParams.add('jobRole=${workerFilter.customOccupation ?? workerFilter.occupation}');
      if (workerFilter.workType != null) queryParams.add('employmentType=${workerFilter.workType}');
      if (workerFilter.experience != null) queryParams.add('experience=${workerFilter.experience}');
      if (workerFilter.location != null) {
        if (workerFilter.location!['state'] != null) queryParams.add('state=${workerFilter.location!['state']}');
        if (workerFilter.location!['district'] != null) queryParams.add('district=${workerFilter.location!['district']}');
        if (workerFilter.location!['mandal'] != null) queryParams.add('mandal=${workerFilter.location!['mandal']}');
      }
    }

    final path = queryParams.isEmpty ? '/jobs' : '/jobs?${queryParams.join('&')}';
    return _client.get(path, auth: true);
  }
}
