import 'api_client.dart';

class ApplicationService {
  ApplicationService._();
  static final ApplicationService instance = ApplicationService._();

  final _client = ApiClient.instance;

  Future<ApiResult<Map<String, dynamic>>> getJobApplicants(String jobId) {
    return _client.get('/applications/job/$jobId', auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> updateApplicationStatus({
    required String applicationId,
    required String status,
    String? rejectionReason,
  }) {
    return _client.put(
      '/applications/$applicationId/status',
      {
        'status': status,
        if (rejectionReason != null) 'rejectionReason': rejectionReason,
      },
      auth: true,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> applyToJob(String jobId, {String? workerProfileId}) {
    return _client.post(
      '/applications',
      {
        'jobId': jobId,
        if (workerProfileId != null) 'workerProfileId': workerProfileId,
      },
      auth: true,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> getEmployerApplications() {
    return _client.get('/applications/employer', auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> completeAndRateApplication({
    required String applicationId,
    required int rating,
    String? comment,
  }) {
    return _client.post(
      '/applications/$applicationId/complete',
      {
        'rating': rating,
        if (comment != null) 'comment': comment,
      },
      auth: true,
    );
  }
  Future<ApiResult<Map<String, dynamic>>> getWorkerApplications() {
    return _client.get('/applications/worker/mine', auth: true);
  }
}
