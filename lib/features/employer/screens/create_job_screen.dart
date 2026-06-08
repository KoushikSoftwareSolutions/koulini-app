import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/job_service.dart';
import 'post_success_screen.dart';

class CreateJobScreen extends StatefulWidget {
  final bool isWork;
  const CreateJobScreen({
    super.key,
    this.isWork = false,
  });

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  int _currentStep = 1;
  bool _isLoading = false;
  
  // Form controllers
  final _titleController = TextEditingController();
  final _customTitleController = TextEditingController();
  final _customCategoryController = TextEditingController();
  final _salaryController = TextEditingController(text: '700');
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _contactNameController = TextEditingController(text: 'Ravi Sharma');
  final _villageController = TextEditingController();

  // Selections
  String? _selectedJobTitle;
  String? _selectedCategory;
  String _noOfOpenings = '1';
  String _jobType = 'Full Time';
  String? _selectedDuration;
  
  // Step 2 Selections
  String? _selectedPayType;
  String? _selectedState;
  String? _selectedDistrict;
  String? _selectedMandal;

  // Step 3 Selections
  bool _resumeCompulsory = false;
  final Set<String> _selectedWorkDescriptions = {};
  final Set<String> _selectedWorkRequirements = {};

  final List<String> _states = ['Andhra Pradesh', 'Telangana', 'Karnataka', 'Tamil Nadu'];
  final List<String> _districts = ['Krishna', 'Guntur', 'NTR', 'Visakhapatnam'];
  final List<String> _mandals = ['Machilipatnam', 'Pedana', 'Gudivada', 'Avanigadda'];

  final List<String> _workDescriptionOptions = [
    'House construction work',
    'Tile renovation & laying',
    'Wall painting & finishing',
    'Plumbing & fixture repair',
    'Electric wiring & setup',
    'Farming & crop harvesting',
  ];

  final List<String> _workRequirementOptions = [
    'Must have own tools',
    'Prior experience required',
    'Physical fitness required',
    'No tools needed',
    'Punctual and reliable',
  ];

  // Predefined data maps (Job Title -> Categories)
  final Map<String, List<String>> _jobData = {
    'Trainers': [
      'Gym Trainer',
      'Yoga Trainer',
      'Dance Trainer',
      'Sports Coach',
    ],
    'Construction': [
      'Mason',
      'Carpenter',
      'Plumber',
      'Electrician',
      'Painter',
    ],
    'Drivers': [
      'Car Driver',
      'Truck Driver',
      'Delivery Driver',
    ],
    'House Help': [
      'Cook/Chef',
      'Maid/Cleaner',
      'Babysitter',
    ],
  };

  final List<String> _durations = [
    '1 Day',
    '3 Days',
    '1 Week',
    '2 Weeks',
    '1 Month',
    '3 Months',
    '6+ Months',
  ];

  @override
  Widget build(BuildContext context) {
    final titleText = widget.isWork ? 'Post a Work' : 'Post a Job';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textBlack, size: 20.sp),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          titleText,
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.only(right: 24.w),
              child: Text(
                'Step $_currentStep of 3',
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLightGray,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Linear Progress Indicator
            PreferredSize(
              preferredSize: Size.fromHeight(4.h),
              child: LinearProgressIndicator(
                value: _currentStep / 3,
                backgroundColor: AppColors.borderGray.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: _buildStepContent(),
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1BasicInfo();
      case 2:
        return _buildStep2SalaryLocation();
      case 3:
        return _buildStep3Review();
      default:
        return Container();
    }
  }

  // --- STEP 1: BASIC INFO ---
  Widget _buildStep1BasicInfo() {
    final subtitleText = widget.isWork 
        ? 'tell workers what the work is about' 
        : 'Tell workers what the job is about';
        
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: AppTextStyles.questionTitle.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitleText,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textLightGray,
          ),
        ),
        SizedBox(height: 24.h),

        // Job Title Dropdown
        _buildLabel('Job Title *'),
        _buildJobTitleDropdown(),
        SizedBox(height: 20.h),

        // Category / Specialty Dropdown
        _buildLabel(widget.isWork ? 'Category *' : 'Job Category *'),
        _buildCategoryDropdown(),
        SizedBox(height: 8.h),
        
        // Custom Job Suggestion Link
        _buildSuggestionLink(),
        SizedBox(height: 20.h),

        // No of Workers / Openings
        _buildLabel(widget.isWork ? 'No. of Workers *' : 'No. of Openings *'),
        _buildNumberSelector(),
        SizedBox(height: 20.h),

        // Work Type / Job Type
        _buildLabel(widget.isWork ? 'Work Type *' : 'Job Type *'),
        _buildTypeSelector(),
        SizedBox(height: 20.h),

        // Work Duration
        _buildLabel(widget.isWork ? 'Work Duration *' : 'Job Duration *'),
        _buildDurationDropdown(),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildJobTitleDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedJobTitle,
          hint: Text(
            'Select Job Title',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          decoration: const InputDecoration(border: InputBorder.none),
          items: _jobData.keys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.poppins(fontSize: 15.sp)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedJobTitle = newValue;
              _selectedCategory = null; // Reset category when title changes
            });
          },
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = _selectedJobTitle != null ? _jobData[_selectedJobTitle!]! : <String>[];
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedCategory,
          disabledHint: Text(
            'Select Job Title first',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          hint: Text(
            'Select Category',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          decoration: const InputDecoration(border: InputBorder.none),
          items: categories.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.poppins(fontSize: 15.sp)),
            );
          }).toList(),
          onChanged: _selectedJobTitle == null ? null : (newValue) {
            setState(() {
              _selectedCategory = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSuggestionLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _showSuggestionDialog,
        child: Text(
          "Can't find your Job Title or Category? Let us know",
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryPurple,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _showSuggestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          title: Text(
            'Suggest Title / Category',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tell us what job title or employee type you are looking for, and we will add it in the future.',
                style: GoogleFonts.poppins(fontSize: 13.sp, color: AppColors.textGray),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _customTitleController,
                decoration: InputDecoration(
                  labelText: 'Job Title',
                  labelStyle: GoogleFonts.poppins(fontSize: 13.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _customCategoryController,
                decoration: InputDecoration(
                  labelText: 'Category / Employee Type',
                  labelStyle: GoogleFonts.poppins(fontSize: 13.sp),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textGray)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you! We will review and add this job title/employee in the future.'),
                    backgroundColor: AppColors.primaryPurple,
                  ),
                );
                _customTitleController.clear();
                _customCategoryController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              ),
              child: Text('Submit Suggestion', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNumberSelector() {
    final options = ['1', '2', '3', '5', '10+'];
    return Row(
      children: options.map((option) {
        final isSelected = _noOfOpenings == option;
        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: GestureDetector(
            onTap: () => setState(() => _noOfOpenings = option),
            child: Container(
              width: 50.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.borderGray.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textBlack,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypeSelector() {
    final options = ['Full Time', 'Part time', 'Seasonal', 'One time'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: options.map((option) {
          final isSelected = _jobType == option;
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: GestureDetector(
              onTap: () => setState(() => _jobType = option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryPurple : Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryPurple : AppColors.borderGray.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textBlack,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDurationDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedDuration,
          hint: Text(
            'Select duration',
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          decoration: const InputDecoration(border: InputBorder.none),
          items: _durations.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: GoogleFonts.poppins(fontSize: 15.sp)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedDuration = newValue;
            });
          },
        ),
      ),
    );
  }

  // --- STEP 2: SALARY & LOCATION ---
  Widget _buildStep2SalaryLocation() {
    final subtitleText = widget.isWork
        ? 'Set Pay and where the work is located'
        : 'Set Pay and where the job is located';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary & Location',
          style: AppTextStyles.questionTitle.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitleText,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textLightGray,
          ),
        ),
        SizedBox(height: 24.h),

        // Pay Type (Optional)
        _buildLabel('Pay Type (Optional)'),
        _buildPayTypeSelector(),
        SizedBox(height: 20.h),

        // Pay Amount
        _buildLabel(widget.isWork ? 'Pay amount *' : 'Pay amount *'),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
          ),
          child: TextFormField(
            controller: _salaryController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.poppins(fontSize: 15.sp),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 40.w,
                alignment: Alignment.center,
                child: Text(
                  '₹',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
              hintText: 'Enter pay amount',
              hintStyle: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 24.h),

        // Location header
        _buildLabel('Location *'),

        // Detect Location automatically
        GestureDetector(
          onTap: () {
            setState(() {
              _selectedState = 'Andhra Pradesh';
              _selectedDistrict = 'Krishna';
              _selectedMandal = 'Machilipatnam';
              _villageController.text = 'Chilakalapudi';
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Location detected automatically!'),
                backgroundColor: const Color(0xFF4CAF50),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(Icons.my_location, color: Colors.white, size: 20.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detect my location automatically',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                      Text(
                        'GPS detection — most accurate',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: AppColors.textLightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textLightGray, size: 20.sp),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // State Dropdown
        _buildLabel('State *'),
        _buildLocationDropdown(
          hint: 'Select State',
          value: _selectedState,
          items: _states,
          onChanged: (newValue) => setState(() => _selectedState = newValue),
        ),
        SizedBox(height: 16.h),

        // District Dropdown
        _buildLabel('District *'),
        _buildLocationDropdown(
          hint: 'Select District',
          value: _selectedDistrict,
          items: _districts,
          onChanged: (newValue) => setState(() => _selectedDistrict = newValue),
        ),
        SizedBox(height: 16.h),

        // Mandal Dropdown
        _buildLabel('Mandal *'),
        _buildLocationDropdown(
          hint: 'Select Mandal',
          value: _selectedMandal,
          items: _mandals,
          onChanged: (newValue) => setState(() => _selectedMandal = newValue),
        ),
        SizedBox(height: 16.h),

        // Village Field (Optional)
        _buildLabel('Village (Optional)'),
        _buildTextField(_villageController, 'Enter Village name'),
        SizedBox(height: 20.h),

        // Additional Description Details
        _buildLabel('Additional Details / Requirements'),
        _buildTextField(_descriptionController, 'e.g. Must bring own tools, timings...', maxLines: 4),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildPayTypeSelector() {
    final options = ['Per Day', 'Per Week', 'Per Month', 'Fixed'];
    return Row(
      children: options.map((option) {
        final isSelected = _selectedPayType == option;
        return Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedPayType = null; // Toggle off to remain optional
                } else {
                  _selectedPayType = option;
                }
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.borderGray.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                option,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textBlack,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          ),
          decoration: const InputDecoration(border: InputBorder.none),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val, style: GoogleFonts.poppins(fontSize: 15.sp)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // --- STEP 3: REVIEW / DESCRIPTION ---
  Widget _buildStep3Review() {
    final titleText = widget.isWork ? 'Work description' : 'Job description';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: AppTextStyles.questionTitle.copyWith(fontSize: 22.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          'Help workers understand what is needed',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.textLightGray,
          ),
        ),
        SizedBox(height: 24.h),

        // Description
        _buildLabel(widget.isWork ? 'Work Description (Optional)' : 'Description (Optional)'),
        if (widget.isWork) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _workDescriptionOptions.map((desc) {
              final isSelected = _selectedWorkDescriptions.contains(desc);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedWorkDescriptions.remove(desc);
                    } else {
                      _selectedWorkDescriptions.add(desc);
                    }
                  });
                },
                child: Chip(
                  label: Text(desc),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: isSelected ? Colors.white : AppColors.textBlack,
                  ),
                  backgroundColor: isSelected ? AppColors.primaryPurple : const Color(0xFFF5F5F5),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
        ],
        _buildTextField(
          _descriptionController, 
          widget.isWork ? 'Or type custom description here...' : 'Describe the job details...', 
          maxLines: 4
        ),
        SizedBox(height: 24.h),

        // Requirements
        _buildLabel(widget.isWork ? 'Requirements (Optional)' : 'Requirements *'),
        if (widget.isWork) ...[
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _workRequirementOptions.map((req) {
              final isSelected = _selectedWorkRequirements.contains(req);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedWorkRequirements.remove(req);
                    } else {
                      _selectedWorkRequirements.add(req);
                    }
                  });
                },
                child: Chip(
                  label: Text(req),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: isSelected ? Colors.white : AppColors.textBlack,
                  ),
                  backgroundColor: isSelected ? AppColors.primaryPurple : const Color(0xFFF5F5F5),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
        ],
        _buildTextField(
          _requirementsController, 
          widget.isWork ? 'Or type custom requirements here...' : 'e.g. Must have own tools, experience preferred...', 
          maxLines: 4
        ),
        SizedBox(height: 24.h),

        // Contact Name
        _buildLabel('Contact name *'),
        _buildTextField(_contactNameController, 'Enter contact name'),
        SizedBox(height: 16.h),

        // Hidden Number Warning Note
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Icon(Icons.lock_outline_rounded, color: Colors.blue.shade700, size: 20.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Your contact number will be hidden until you approve the applications.',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Resume Compulsory Switch (Jobs only)
        if (!widget.isWork) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resume compulsory',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  Text(
                    'Applicants must upload a resume to apply',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.textLightGray,
                    ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: _resumeCompulsory,
                activeColor: AppColors.primaryPurple,
                onChanged: (val) => setState(() => _resumeCompulsory = val),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ],
    );
  }

  // --- GENERAL BUILDERS ---
  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGray.withValues(alpha: 0.2)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: AppColors.textLightGray, fontSize: 14.sp),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> _submitJob() async {
    final salary = _salaryController.text.trim();
    final state = _selectedState;
    final district = _selectedDistrict;
    final mandal = _selectedMandal;
    final contactName = _contactNameController.text.trim();

    if (salary.isEmpty || state == null || district == null || mandal == null || contactName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields marked with *'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Map jobType string to backend enum
    String mappedJobType = 'Full';
    if (_jobType == 'Part time') mappedJobType = 'Part';
    if (_jobType == 'Seasonal') mappedJobType = 'Seasonal';
    if (_jobType == 'One time') mappedJobType = 'One-time';

    int openings = 1;
    if (_noOfOpenings == '10+') {
      openings = 10;
    } else {
      openings = int.tryParse(_noOfOpenings) ?? 1;
    }

    final jobTitle = _selectedJobTitle ??
        (_titleController.text.trim().isNotEmpty
            ? _titleController.text.trim()
            : (_selectedCategory ?? (widget.isWork ? 'Work Posting' : 'Job Posting')));

    final jobData = {
      'title': jobTitle,
      'category': _selectedCategory ??
          (_customCategoryController.text.trim().isNotEmpty
              ? _customCategoryController.text.trim()
              : 'General'),
      'jobType': mappedJobType,
      'duration': _selectedDuration,
      'numberOfOpenings': openings,
      'payType': _selectedPayType ?? 'Per Day',
      'salary': salary,
      'description': _descriptionController.text.trim(),
      'requirements': widget.isWork 
          ? _selectedWorkRequirements.toList() 
          : _requirementsController.text.trim().split('\n').where((r) => r.isNotEmpty).toList(),
      'workDescriptions': _selectedWorkDescriptions.toList(),
      'isWork': widget.isWork,
      'resumeRequired': _resumeCompulsory,
      'contactName': contactName,
      'location': {
        'state': state,
        'district': district,
        'mandal': mandal,
        if (_villageController.text.trim().isNotEmpty) 'village': _villageController.text.trim(),
      }
    };

    final result = await JobService.instance.createJob(jobData);

    setState(() => _isLoading = false);

    if (result.success) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PostSuccessScreen(
              isWork: widget.isWork,
              title: jobTitle,
              wage: salary,
              type: _jobType,
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error ?? 'Failed to create job posting. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildBottomButton() {
    String buttonText = 'Next: Salary & Location';
    if (_currentStep == 2) buttonText = 'Next: Description';
    if (_currentStep == 3) buttonText = widget.isWork ? 'Post Work' : 'Post Job';

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
        onPressed: _isLoading 
            ? null 
            : () {
                if (_currentStep < 3) {
                  setState(() => _currentStep++);
                } else {
                  _submitJob();
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 56.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 0,
        ),
        child: _isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                buttonText,
                style: GoogleFonts.poppins(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
