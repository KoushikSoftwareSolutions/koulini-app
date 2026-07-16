enum UserRole { worker, job }

class RoleContent {
  final String roleName; // 'Worker' or 'Job'
  
  // Role Selection
  final String roleSelectionContinueButton;

  // Personal Details
  final String personalDetailsSubtitle;
  
  // Professional Details
  final String professionalDetailsTitle;
  final String professionalDetailsSubtitle;
  final String primaryWorkLabel;
  final String primaryWorkHint;
  final String customWorkLabel;
  final String customWorkReviewTitle;
  final String customWorkReviewHint;
  final String noPrimarySkillError;
  final String noCustomSkillError;

  // Success Screen
  final String successMessage;
  final String step1Title;
  final String step1Subtitle;
  final String step2Title;
  final String step2Subtitle;
  final String step3Title;
  final String step3Subtitle;
  final String startFindingButton;

  const RoleContent({
    required this.roleName,
    required this.roleSelectionContinueButton,
    required this.personalDetailsSubtitle,
    required this.professionalDetailsTitle,
    required this.professionalDetailsSubtitle,
    required this.primaryWorkLabel,
    required this.primaryWorkHint,
    required this.customWorkLabel,
    required this.customWorkReviewTitle,
    required this.customWorkReviewHint,
    required this.noPrimarySkillError,
    required this.noCustomSkillError,
    required this.successMessage,
    required this.step1Title,
    required this.step1Subtitle,
    required this.step2Title,
    required this.step2Subtitle,
    required this.step3Title,
    required this.step3Subtitle,
    required this.startFindingButton,
  });
}

extension UserRoleExtension on UserRole {
  RoleContent get content {
    switch (this) {
      case UserRole.worker:
        return const RoleContent(
          roleName: 'Worker',
          roleSelectionContinueButton: 'Continue as Worker',
          personalDetailsSubtitle: 'Business owners use this to find the right person.',
          professionalDetailsTitle: 'Primary Work & Experience',
          professionalDetailsSubtitle: 'Select your primary trade and experience level.',
          primaryWorkLabel: 'Primary Work',
          primaryWorkHint: 'Select your primary work',
          customWorkLabel: 'My work is not listed above',
          customWorkReviewTitle: 'Review your work skill',
          customWorkReviewHint: 'Type your work skill here (e.g. Plumber)',
          noPrimarySkillError: 'Please select a primary work',
          noCustomSkillError: 'Please type your custom work name',
          successMessage: 'Your KaamKaro profile is ready. Start exploring work near you!',
          step1Title: 'Business owners will find your profile',
          step1Subtitle: 'Your skills are now searchable',
          step2Title: 'Get work alerts',
          step2Subtitle: "We'll notify you of matching work",
          step3Title: 'Apply in one tap',
          step3Subtitle: 'No lengthy forms needed',
          startFindingButton: 'Start Finding Work',
        );
      case UserRole.job:
        return const RoleContent(
          roleName: 'Job',
          roleSelectionContinueButton: 'Continue as Job seeker',
          personalDetailsSubtitle: 'Employers use this to find the right person.',
          professionalDetailsTitle: 'Job Category & Experience',
          professionalDetailsSubtitle: 'Select the job category you specialize in.',
          primaryWorkLabel: 'Job Category',
          primaryWorkHint: 'Select your job category',
          customWorkLabel: 'My job is not listed above',
          customWorkReviewTitle: 'Review your job title',
          customWorkReviewHint: 'Type your job title here (e.g. Priest)',
          noPrimarySkillError: 'Please select a job category',
          noCustomSkillError: 'Please type your custom job title',
          successMessage: 'Your KaamKaro profile is ready. Start exploring jobs near you!',
          step1Title: 'Employers will find your profile',
          step1Subtitle: 'Your skills are now searchable',
          step2Title: 'Get job alerts',
          step2Subtitle: "We'll notify you of matching jobs",
          step3Title: 'Apply in one tap',
          step3Subtitle: 'No lengthy forms needed',
          startFindingButton: 'Start Finding Jobs',
        );
    }
  }

  String get value => this == UserRole.worker ? 'Worker' : 'Jobs';

  static UserRole fromString(String? role) {
    if (role?.toLowerCase() == 'jobs' || role?.toLowerCase() == 'job') {
      return UserRole.job;
    }
    return UserRole.worker;
  }
}
