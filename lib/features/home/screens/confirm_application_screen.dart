import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/services/application_service.dart';
import '../../../core/services/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'application_success_screen.dart';
import '../../../../main.dart';

class ConfirmApplicationScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const ConfirmApplicationScreen({
    super.key,
    required this.job,
  });

  @override
  State<ConfirmApplicationScreen> createState() => _ConfirmApplicationScreenState();
}

class _ConfirmApplicationScreenState extends State<ConfirmApplicationScreen> {
  bool _isSubmitting = false;
  bool _isLoadingProfiles = true;
  List<dynamic> _managedProfiles = [];
  Map<String, dynamic>? _selectedProfileData;
  String? _selectedProfileId;
  String? _uploadedResumeName;

  @override
  void initState() {
    super.initState();
    _fetchManagedProfiles();
  }

  Future<void> _fetchManagedProfiles() async {
    if (MyApp.userRole != 'Worker') {
      setState(() => _isLoadingProfiles = false);
      return;
    }
    
    final result = await ApiClient.instance.get('/worker-profiles/managed');
    if (mounted) {
      if (result.success && result.data != null) {
         final allProfiles = result.data!['data'] as List<dynamic>? ?? [];
         _managedProfiles = allProfiles.where((p) => p['status'] != 'Archived').toList();
      }
      setState(() => _isLoadingProfiles = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final profile = _selectedProfileData ?? authState.profile;

    final String name = profile?['name'] ?? (MyApp.userRole == 'Worker' ? 'Worker' : 'Applicant');
    final String skill = profile?['primarySkill'] ?? profile?['customSkill'] ?? (MyApp.userRole == 'Worker' ? 'General Worker' : 'Professional');
    final loc = profile?['location'] as Map<String, dynamic>?;
    final String location = loc != null
        ? '${loc['village'] ?? loc['mandal'] ?? ''}, ${loc['district'] ?? ''}'.trim()
        : 'Krishna, Andhra Pradesh';
    final String experience = profile?['experienceLevel'] ?? 'No Experience';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Confirm Application',
          style: GoogleFonts.poppins(
            color: AppColors.textBlack,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _isSubmitting
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCondensedJobCard(),
                          SizedBox(height: 32.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Applying As:',
                                style: AppTextStyles.questionTitle.copyWith(
                                  fontSize: 18.sp,
                                ),
                              ),
                              if (!_isLoadingProfiles && _managedProfiles.isNotEmpty)
                                TextButton.icon(
                                  onPressed: _showProfileSelection,
                                  icon: const Icon(Icons.switch_account, size: 18, color: AppColors.primaryPurple),
                                  label: Text(
                                    'Switch',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.primaryPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _buildProfileCard(name, skill, location, experience),
                          if (widget.job['resumeRequired'] == true) ...[
                            SizedBox(height: 24.h),
                            _buildResumeUploadSection(),
                          ],
                        ],
                      ),
                    ),
                  ),
                  _buildBottomButton(context),
                ],
              ),
      ),
    );
  }

  Widget _buildCondensedJobCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 90.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Applying for',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.job['title'] ?? 'Mason Required',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${widget.job['company'] ?? 'Vijay Constructions'}  |  ${widget.job['location'] ?? 'Machilipatnam'}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.textLightGray,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Rs.${widget.job['salary'] ?? '700/day'}',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(String name, String skill, String location, String experience) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderGray.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileField('Name', name),
          _detailDivider(),
          _buildProfileField('Skills', skill),
          _detailDivider(),
          _buildProfileField('Location', location),
          _detailDivider(),
          _buildProfileField('Experience', experience),
          _detailDivider(),
          _buildProfileField('Phone', 'Hidden until approved'),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.textGray.withValues(alpha: 0.6),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        color: AppColors.borderGray.withValues(alpha: 0.05),
        thickness: 1,
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitApplication,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r)),
          elevation: 6,
          shadowColor: AppColors.primaryPurple.withValues(alpha: 0.4),
        ),
        child: Text(
          'Submit Application',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  Widget _buildResumeUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resume Required *',
          style: AppTextStyles.questionTitle.copyWith(
            fontSize: 18.sp,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _simulateResumeUpload,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _uploadedResumeName != null
                    ? const Color(0xFF4CAF50)
                    : AppColors.borderGray.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _uploadedResumeName != null ? Icons.picture_as_pdf_rounded : Icons.cloud_upload_outlined,
                  color: _uploadedResumeName != null ? const Color(0xFF4CAF50) : AppColors.primaryPurple,
                  size: 28.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _uploadedResumeName ?? 'Upload Resume',
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: _uploadedResumeName != null ? AppColors.textBlack : AppColors.textGray,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _uploadedResumeName != null ? 'Format: PDF' : 'PDF format only (Max 5MB)',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.textLightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_uploadedResumeName != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () => setState(() => _uploadedResumeName = null),
                  )
                else
                  Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: AppColors.textLightGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _simulateResumeUpload() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Resume from Files',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 20.h),
              _buildResumeFileItem('Koulini_Resume_2026.pdf'),
              SizedBox(height: 12.h),
              _buildResumeFileItem('Professional_CV_Koushik.pdf'),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitApplication() async {
    final jobId = widget.job['id']?.toString();
    if (jobId == null || jobId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid Job ID.')),
      );
      return;
    }

    if (widget.job['resumeRequired'] == true && _uploadedResumeName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload a resume to apply.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final result = await ApplicationService.instance.applyToJob(
       jobId, 
       workerProfileId: _selectedProfileId, // null means Root profile
    );

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ApplicationSuccessScreen(job: widget.job),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Failed to submit application.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showProfileSelection() async {
    final authState = Provider.of<AuthState>(context, listen: false);
    final myProfile = authState.profile;

    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Profile to Apply',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack,
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView(
                   children: [
                      ListTile(
                         leading: CircleAvatar(
                           backgroundImage: NetworkImage(myProfile?['profilePhoto'] ?? 'https://i.pravatar.cc/150'),
                         ),
                         title: Text('My Profile (Root)', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                         onTap: () => Navigator.pop(context, myProfile),
                      ),
                      const Divider(),
                      ..._managedProfiles.map((p) => ListTile(
                         leading: CircleAvatar(
                           backgroundImage: NetworkImage(p['profilePhoto'] ?? 'https://i.pravatar.cc/150'),
                         ),
                         title: Text(p['name'] ?? 'Worker', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                         subtitle: Text(p['relationship'] ?? ''),
                         onTap: () => Navigator.pop(context, p as Map<String, dynamic>),
                      )),
                   ]
                )
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
       setState(() {
         _selectedProfileId = selected['_id']; // root profile won't have _id (unless it does, backend handles null as root)
         _selectedProfileData = selected;
       });
    }
  }

  Widget _buildResumeFileItem(String name) {
    return ListTile(
      leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryPurple),
      onTap: () {
        setState(() {
          _uploadedResumeName = name;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Uploaded $name successfully!'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
