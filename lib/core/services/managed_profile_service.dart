import 'api_client.dart';

class ManagedProfileService {
  ManagedProfileService._();
  static final ManagedProfileService instance = ManagedProfileService._();

  Future<ApiResult<Map<String, dynamic>>> getManagedProfiles() async {
    return await ApiClient.instance.get('/worker-profiles/managed');
  }

  Future<ApiResult<Map<String, dynamic>>> createManagedProfile(Map<String, dynamic> data) async {
    return await ApiClient.instance.post('/worker-profiles/managed', data);
  }

  Future<ApiResult<Map<String, dynamic>>> updateManagedProfile(String id, Map<String, dynamic> data) async {
    return await ApiClient.instance.put('/worker-profiles/managed/$id', data);
  }

  Future<ApiResult<Map<String, dynamic>>> archiveManagedProfile(String id) async {
    return await ApiClient.instance.put('/worker-profiles/managed/$id/archive', {});
  }

  Future<ApiResult<Map<String, dynamic>>> restoreManagedProfile(String id) async {
    return await ApiClient.instance.put('/worker-profiles/managed/$id/restore', {});
  }
}
