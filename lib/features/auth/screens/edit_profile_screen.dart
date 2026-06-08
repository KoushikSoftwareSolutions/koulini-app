import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/premium_image.dart';
import '../widgets/gender_selector.dart';
import '../widgets/skill_tag.dart';
import '../../../../main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _aboutController;
  final _otherReviewController = TextEditingController();
  
  String _selectedGender = 'Male';
  String _primarySkill = '';
  String _experience = 'No Experience';
  String? _aadhaarPhoto;
  String? _profilePhotoUrl;
  bool _isSaving = false;

  // Skills lists
  final List<String> _workerPrimarySkills = ['Mason', 'Electrician', 'Plumber', 'Carpenter', 'Painter', 'Driver', 'Construction Labour'];
  final List<String> _jobsPrimarySkills = ['Priest', 'Teacher', 'Nurse', 'Trainer', 'Pharmacist', 'Warden'];

  final Set<String> _selectedOtherSkills = {'Mason', 'Tile Work', 'Plastering', 'Painting'};

  // Work Gallery State (Workers)
  final List<Map<String, String>> _workGallery = [
    {
      'title': 'Foundation Work',
      'details': 'Reinforced concrete foundation for a 2-story house.',
      'image': 'https://images.unsplash.com/photo-1590060335586-4805d7f3d217?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Tile Installation',
      'details': 'Italian marble tiling for living room area.',
      'image': 'https://images.unsplash.com/photo-1581094288338-2314dddb7ecb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
    },
  ];

  // Job History State (Jobs)
  final List<Map<String, String>> _jobHistory = [
    {
      'company': 'Public School',
      'year': '2024',
      'details': 'Primary School Teacher — 1 year',
    },
    {
      'company': 'City Clinic',
      'year': '2023',
      'details': 'Junior Pharmacist — 6 months',
    },
  ];

  // Location Controllers
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _mandalController;
  late TextEditingController _villageController;

  @override
  void initState() {
    super.initState();
    final authState = Provider.of<AuthState>(context, listen: false);
    final profile = authState.profile;

    _nameController = TextEditingController(text: profile?['name'] ?? '');
    _phoneController = TextEditingController(text: profile?['phone'] ?? authState.pendingPhone ?? '');
    _aboutController = TextEditingController(
      text: profile?['about'] ?? 
          'Experienced professional dedicated to delivering high-quality results. Reliable and detail-oriented.'
    );
    _selectedGender = profile?['gender'] ?? 'Male';
    _primarySkill = profile?['primarySkill'] ?? (MyApp.userRole == 'Worker' ? 'Mason' : 'Teacher');
    _experience = profile?['experienceLevel'] ?? 'No Experience';
    _aadhaarPhoto = profile?['aadhaarPhoto'];
    _profilePhotoUrl = profile?['profilePhoto'];

    final loc = profile?['location'] as Map<String, dynamic>?;
    _stateController = TextEditingController(text: loc?['state'] ?? 'Andhra Pradesh');
    _districtController = TextEditingController(text: loc?['district'] ?? 'Krishna');
    _mandalController = TextEditingController(text: loc?['mandal'] ?? 'Machilipatnam');
    _villageController = TextEditingController(text: loc?['village'] ?? 'Machilipatnam');

    if (profile?['otherSkills'] != null) {
      _selectedOtherSkills.clear();
      _selectedOtherSkills.addAll(List<String>.from(profile!['otherSkills']));
    }
    if (profile?['workGallery'] != null) {
      _workGallery.clear();
      _workGallery.addAll(
        List<dynamic>.from(profile!['workGallery']).map((item) => {
          'title': item['title']?.toString() ?? '',
          'details': item['details']?.toString() ?? '',
          'image': item['image']?.toString() ?? '',
        }).toList()
      );
    }
    _otherReviewController.text = profile?['otherReview'] ?? '';
    if (profile?['jobHistory'] != null) {
      _jobHistory.clear();
      _jobHistory.addAll(
        List<dynamic>.from(profile!['jobHistory']).map((item) => {
          'company': item['company']?.toString() ?? '',
          'year': item['year']?.toString() ?? '',
          'details': item['details']?.toString() ?? '',
        }).toList()
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    _otherReviewController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _mandalController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final authState = Provider.of<AuthState>(context, listen: false);

    setState(() {
      _isSaving = true;
    });

    final payload = {
      'name': _nameController.text.trim(),
      'gender': _selectedGender,
      'phone': _phoneController.text.trim(),
      'primarySkill': _primarySkill,
      'experienceLevel': _experience,
      if (_aadhaarPhoto != null) 'aadhaarPhoto': _aadhaarPhoto,
      if (_profilePhotoUrl != null) 'profilePhoto': _profilePhotoUrl,
      'about': _aboutController.text.trim(),
      'location': {
        'state': _stateController.text.trim(),
        'district': _districtController.text.trim(),
        'mandal': _mandalController.text.trim(),
        'village': _villageController.text.trim(),
      },
      'otherSkills': _selectedOtherSkills.toList(),
      'workGallery': _workGallery,
      'otherReview': _otherReviewController.text.trim(),
      'jobHistory': _jobHistory,
    };

    final success = await authState.updateProfile(payload);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.error ?? 'Failed to save changes'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWorker = MyApp.userRole == 'Worker';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isSaving
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          _buildAvatarEdit(),
                          SizedBox(height: 32.h),
                          
                          _buildSectionHeader('Personal Details'),
                          _buildLabel('Full Name'),
                          _buildTextField(_nameController, 'Enter your name'),
                          SizedBox(height: 16.h),
                          _buildLabel('Gender'),
                          GenderSelector(
                            selectedGender: _selectedGender,
                            onGenderSelected: (gender) => setState(() => _selectedGender = gender),
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Phone Number'),
                          _buildTextField(_phoneController, 'Enter phone number', keyboardType: TextInputType.phone),
                          SizedBox(height: 20.h),
                          _buildLabel('Aadhaar Card Photo'),
                          _buildAadhaarPhotoWidget(),
                          
                          SizedBox(height: 32.h),
                          _buildSectionHeader('Professional Profile'),
                          _buildLabel('Primary Skill'),
                          _buildPrimarySkillDropdown(isWorker),
                          SizedBox(height: 20.h),
                          _buildLabel('Years of Experience'),
                          _buildExperienceDropdown(),
                          
                          if (isWorker) ...[
                            SizedBox(height: 20.h),
                            _buildLabel('Other Skills'),
                            _buildOtherSkillsWrap(),
                            SizedBox(height: 32.h),
                            _buildWorkGallerySection(),
                          ] else ...[
                            SizedBox(height: 20.h),
                            _buildLabel('Review of Other Jobs You Can Do'),
                            _buildLargeTextField(_otherReviewController, 'Type other job skills you can perform...'),
                            SizedBox(height: 32.h),
                            _buildJobHistorySection(),
                          ],
                          
                          SizedBox(height: 32.h),
                          _buildSectionHeader('Location'),
                          _buildLabel('State'),
                          _buildTextField(_stateController, 'Enter State'),
                          SizedBox(height: 16.h),
                          _buildLabel('District'),
                          _buildTextField(_districtController, 'Enter District'),
                          SizedBox(height: 16.h),
                          _buildLabel('Mandal'),
                          _buildTextField(_mandalController, 'Enter Mandal'),
                          SizedBox(height: 16.h),
                          _buildLabel('Village'),
                          _buildTextField(_villageController, 'Enter Village'),
                          
                          SizedBox(height: 32.h),
                          _buildSectionHeader('About Yourself'),
                          _buildLargeTextField(_aboutController, 'Tell us about yourself...'),
                          
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                  _buildSaveButton(),
                ],
              ),
      ),
    );
  }

  Widget _buildAadhaarPhotoWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _aadhaarPhoto = 'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aadhaar photo uploaded successfully! Save to apply.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
        ),
        child: _aadhaarPhoto != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: Stack(
                  children: [
                    PremiumImage(
                      imageUrl: _aadhaarPhoto!,
                      height: 120.h,
                      width: double.infinity,
                    ),
                    Container(
                      color: Colors.black.withValues(alpha: 0.15),
                      child: const Center(
                        child: Icon(Icons.check_circle_rounded, color: Color(0xFF4CAF50), size: 36),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_rounded, color: AppColors.textLightGray, size: 32.sp),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload Aadhaar Card Photo',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPrimarySkillDropdown(bool isWorker) {
    final list = List<String>.from(isWorker ? _workerPrimarySkills : _jobsPrimarySkills);
    if (_primarySkill.isNotEmpty && !list.contains(_primarySkill)) {
      list.add(_primarySkill);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _primarySkill,
          isExpanded: true,
          style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
          items: list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _primarySkill = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildExperienceDropdown() {
    final List<String> list = ['No Experience', '1 Year', '2 Years', '3 Years', '4 Years', '5+ Years', '1-2 Years', '2-5 Years', '5-10 Years', '10+ Years'];
    
    // Fallback if current experience value is not in the dropdown list
    final val = list.contains(_experience) ? _experience : 'No Experience';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: val,
          isExpanded: true,
          style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
          items: list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _experience = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildWorkGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Work Gallery'),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _workGallery.length + 1,
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddProjectCard();
              }
              final project = _workGallery[index - 1];
              return _buildProjectEditCard(project, index - 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Job History'),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _jobHistory.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final job = _jobHistory[index];
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFF1F1F1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        job['company']!,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        job['year']!,
                        style: GoogleFonts.poppins(
                          fontSize: 13.sp,
                          color: AppColors.textLightGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    job['details']!,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddProjectCard() {
    return GestureDetector(
      onTap: _showAddProjectDialog,
      child: Container(
        width: 140.w,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add_rounded, color: AppColors.primaryPurple, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              'Add Project',
              style: GoogleFonts.poppins(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectEditCard(Map<String, String> project, int index) {
    return Container(
      width: 140.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: PremiumImage(
                    imageUrl: project['image']!,
                    width: double.infinity,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Text(
                  project['title']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _workGallery.removeAt(index);
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close_rounded, size: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProjectDialog() {
    final titleController = TextEditingController();
    final detailsController = TextEditingController();
    String? tempImagePath;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Project',
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildLabel('Project Title'),
                _buildTextField(titleController, 'e.g. Living Room Tiling'),
                SizedBox(height: 16.h),
                _buildLabel('Project Details'),
                _buildTextField(detailsController, 'Describe what you did...'),
                SizedBox(height: 24.h),
                _buildLabel('Project Photo'),
                GestureDetector(
                  onTap: () => setState(() {
                    tempImagePath = 'https://images.unsplash.com/photo-1504148455328-436277683910?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
                  }),
                  child: Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
                    ),
                    child: tempImagePath != null 
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: PremiumImage(
                            imageUrl: tempImagePath!,
                            height: 120.h,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined, color: AppColors.textLightGray, size: 32.sp),
                            SizedBox(height: 8.h),
                            Text(
                              'Select Photo',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: AppColors.textLightGray,
                                ),
                            ),
                          ],
                        ),
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          side: BorderSide(color: AppColors.borderGray.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            setState(() {
                              _workGallery.add({
                                'title': titleController.text,
                                'details': detailsController.text,
                                'image': tempImagePath ?? 'https://images.unsplash.com/photo-1541963463532-d68292c34b19?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
                              });
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Project',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarEdit() {
    final bool hasPhoto = _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty && !_profilePhotoUrl!.contains('pravatar.cc');

    return Center(
      child: GestureDetector(
        onTap: _showProfilePhotoSourceSheet,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            hasPhoto
                ? CircleAvatar(
                    radius: 50.r,
                    backgroundImage: NetworkImage(_profilePhotoUrl!),
                  )
                : CircleAvatar(
                    radius: 50.r,
                    backgroundColor: const Color(0xFFF3F4F6),
                    child: Icon(Icons.person_rounded, size: 50.r, color: AppColors.textLightGray),
                  ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.primaryPurple,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.camera_alt_rounded, size: 18.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfilePhotoSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Worker Profile Photo',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 24.h),
            _buildSourceOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              onTap: () {
                Navigator.pop(context);
                _showPresetProfilePhotoPicker();
              },
            ),
            _buildSourceOption(
              icon: Icons.photo_library_rounded,
              title: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(context);
                _showPresetProfilePhotoPicker();
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPresetProfilePhotoPicker() {
    final presets = [
      {
        'name': 'Construction',
        'url': 'https://images.unsplash.com/photo-1504307651254-35680f356dfd?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': 'Creative',
        'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': 'Corporate',
        'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': 'Services',
        'url': 'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': 'Professional',
        'url': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&auto=format&fit=crop&q=80',
      },
      {
        'name': 'General',
        'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&auto=format&fit=crop&q=80',
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Premium Preset Photo',
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: presets.length,
                itemBuilder: (context, idx) {
                  final p = presets[idx];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _profilePhotoUrl = p['url'];
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${p['name']} avatar selected! Save to apply.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Column(
                        children: [
                          Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _profilePhotoUrl == p['url']
                                    ? AppColors.primaryPurple
                                    : Colors.transparent,
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(p['url']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            p['name']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primaryPurple, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Divider(color: AppColors.borderGray.withValues(alpha: 0.1))),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textGray.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLargeTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 4,
        style: GoogleFonts.poppins(fontSize: 15.sp, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: EdgeInsets.all(16.w),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildOtherSkillsWrap() {
    final allSkills = ['Mason', 'Tile Work', 'Plastering', 'Painting', 'Carpenter', 'Plumber', 'Electrician'];
    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: allSkills.map((skill) {
        return SkillTag(
          label: skill,
          isSelected: _selectedOtherSkills.contains(skill),
          onTap: () {
            setState(() {
              if (_selectedOtherSkills.contains(skill)) {
                _selectedOtherSkills.remove(skill);
              } else {
                _selectedOtherSkills.add(skill);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
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
        onPressed: _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: Text(
          'Save Changes',
          style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
