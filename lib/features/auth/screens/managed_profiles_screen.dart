import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/services/auth_state.dart';
import '../../../core/services/managed_profile_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/premium_image.dart';
import 'create_worker_profile_screen.dart';

class ManagedProfilesScreen extends StatefulWidget {
  const ManagedProfilesScreen({super.key});

  @override
  State<ManagedProfilesScreen> createState() => _ManagedProfilesScreenState();
}

class _ManagedProfilesScreenState extends State<ManagedProfilesScreen> {
  List<dynamic> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfiles();
  }

  Future<void> _fetchProfiles() async {
    setState(() => _isLoading = true);
    final response = await ManagedProfileService.instance.getManagedProfiles();
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _profiles = response.data!['data'] ?? [];
        }
      });
    }
  }

  Future<void> _archiveProfile(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Profile?'),
        content: const Text('Are you sure you want to archive this profile? It will not appear in employer searches.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      await ManagedProfileService.instance.archiveManagedProfile(id);
      _fetchProfiles();
    }
  }

  Future<void> _restoreProfile(String id) async {
    setState(() => _isLoading = true);
    await ManagedProfileService.instance.restoreManagedProfile(id);
    _fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final myProfile = authState.profile;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textBlack),
        title: Text(
          'My Worker Profiles',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
          : RefreshIndicator(
              onRefresh: _fetchProfiles,
              color: AppColors.primaryPurple,
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  Text(
                    'My Profile (Root Profile)',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildProfileCard(myProfile, isRoot: true),
                  SizedBox(height: 24.h),
                  Text(
                    'Managed Profiles (${_profiles.length}/20)',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLightGray,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ..._profiles.map((p) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildProfileCard(p, isRoot: false),
                      )),
                  SizedBox(height: 20.h),
                  if (_profiles.length < 20)
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateWorkerProfileScreen(),
                          ),
                        );
                        if (result == true) {
                          _fetchProfiles();
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        'Add Worker',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic>? profile, {required bool isRoot}) {
    if (profile == null) return const SizedBox.shrink();
    
    final name = profile['name'] ?? 'Unknown';
    final occupation = profile['primarySkill'] ?? profile['category'] ?? 'Worker';
    final relationship = isRoot ? 'Owner' : (profile['relationship'] ?? 'Managed');
    final avatar = profile['profilePhoto']?.toString() ?? 'https://i.pravatar.cc/150?u=${profile['_id'] ?? name}';
    final loc = profile['location'] as Map<String, dynamic>?;
    final locationName = loc != null 
        ? '${loc['mandal'] ?? loc['village'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : '';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF1F1F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumImage(
            imageUrl: avatar,
            displayName: name,
            width: 60.r,
            height: 60.r,
            isAvatar: true,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    if (profile['status'] == 'Archived') ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Archived',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  occupation,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
                if (locationName.isNotEmpty)
                  Text(
                    locationName,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isRoot ? AppColors.primaryPurple.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    isRoot ? 'Owner' : 'Relationship: $relationship',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isRoot ? AppColors.primaryPurple : Colors.orange.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isRoot)
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppColors.textGray),
              onSelected: (val) async {
                if (val == 'edit') {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateWorkerProfileScreen(
                        isEditing: true,
                        initialData: profile,
                      ),
                    ),
                  );
                  if (result == true) _fetchProfiles();
                } else if (val == 'archive') {
                  _archiveProfile(profile['_id']);
                } else if (val == 'restore') {
                  _restoreProfile(profile['_id']);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit Profile'),
                ),
                if (profile['status'] == 'Archived')
                  const PopupMenuItem(
                    value: 'restore',
                    child: Text('Restore Profile', style: TextStyle(color: AppColors.primaryPurple)),
                  )
                else
                  const PopupMenuItem(
                    value: 'archive',
                    child: Text('Archive Profile', style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
