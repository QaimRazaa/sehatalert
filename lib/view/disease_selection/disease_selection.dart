import 'package:flutter/material.dart';
import 'package:sehatalert/view/home/home.dart';
import '../../data/model/user/user_model.dart';

import '../../data/repository/authentication/authentication_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/section_container.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';

class DiseaseSelection extends StatefulWidget {
  final Map<String, dynamic>? patientData;

  const DiseaseSelection({super.key, this.patientData});

  @override
  State<DiseaseSelection> createState() => _DiseaseSelectionState();
}

class _DiseaseSelectionState extends State<DiseaseSelection> {
  final AuthRepository authRepository = AuthRepository();

  bool hasDiabetes = false;
  bool hasHeartDisease = false;
  bool hasHypertension = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.patientData == null) {
      loadExistingData();
    }
  }

  Future<void> loadExistingData() async {
    final userData = await authRepository.getCurrentUserData();
    if (userData?.patientInfo != null) {
      setState(() {
        hasDiabetes = userData!.patientInfo!.diseases.contains('Diabetes');
        hasHeartDisease = userData.patientInfo!.diseases.contains(
          'Heart Disease',
        );
        hasHypertension = userData.patientInfo!.diseases.contains(
          'Hypertension',
        );
      });
    }
  }

  Future<void> handleContinue() async {
    List<String> selectedDiseases = [];
    if (hasDiabetes) selectedDiseases.add('Diabetes');
    if (hasHeartDisease) selectedDiseases.add('Heart Disease');
    if (hasHypertension) selectedDiseases.add('Hypertension');

    setState(() => isLoading = true);

    try {
      if (widget.patientData != null) {
        // Coming from patient info - save everything
        final emergencyContact = EmergencyContact(
          name: widget.patientData!['emergencyContact']['name'],
          relationship: widget.patientData!['emergencyContact']['relationship'],
          phoneNumber: widget.patientData!['emergencyContact']['phoneNumber'],
        );

        final patientInfo = PatientInfo(
          dateOfBirth: widget.patientData!['dateOfBirth'],
          gender: widget.patientData!['gender'],
          bloodGroup: widget.patientData!['bloodGroup'],
          allergies: widget.patientData!['allergies'],
          emergencyContact: emergencyContact,
          height: widget.patientData!['height'],
          weight: widget.patientData!['weight'],
          city: widget.patientData!['city'],
          diseases: selectedDiseases,
        );

        await authRepository.updatePatientInfo(patientInfo);
      } else {
        // Coming from auth check - update entire patientInfo with new diseases
        final userData = await authRepository.getCurrentUserData();
        if (userData?.patientInfo != null) {
          final updatedPatientInfo = PatientInfo(
            dateOfBirth: userData!.patientInfo!.dateOfBirth,
            gender: userData.patientInfo!.gender,
            bloodGroup: userData.patientInfo!.bloodGroup,
            allergies: userData.patientInfo!.allergies,
            emergencyContact: userData.patientInfo!.emergencyContact,
            height: userData.patientInfo!.height,
            weight: userData.patientInfo!.weight,
            city: userData.patientInfo!.city,
            diseases: selectedDiseases,
          );
          await authRepository.updatePatientInfo(updatedPatientInfo);
        }
      }

      if (mounted) {
        showSuccessSnackBar('Profile completed successfully!');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      showErrorSnackBar('Failed to save profile. Please try again.');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: CustomAppBar(title: l10n.diseaseSelection),
      body: Padding(
        padding: ResponsiveSize.all(4),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SectionContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                        ).createShader(bounds),
                        child: Text(
                          l10n.selectChronicDiseases,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(1)),
                      Text(
                        l10n.selectConditions,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(3)),

                      _buildCheckboxTile(l10n.diabetes, hasDiabetes, (value) {
                        setState(() => hasDiabetes = value ?? false);
                      }),
                      SizedBox(height: ResponsiveSize.h(1)),

                      _buildCheckboxTile(l10n.heartDisease, hasHeartDisease, (
                        value,
                      ) {
                        setState(() => hasHeartDisease = value ?? false);
                      }),
                      SizedBox(height: ResponsiveSize.h(1)),

                      _buildCheckboxTile(l10n.hypertension, hasHypertension, (
                        value,
                      ) {
                        setState(() => hasHypertension = value ?? false);
                      }),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                ),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF14B8A6).withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CustomElevatedButton(
                text: isLoading ? l10n.saving : l10n.continueText,
                backgroundColor: Colors.transparent,
                textColor: AppColors.white,
                onPressed: isLoading ? null : handleContinue,
                width: ResponsiveSize.w(25),
                height: ResponsiveSize.h(.6),
                borderRadius: 5,
              ),
            ),
            SizedBox(height: ResponsiveSize.h(3)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxTile(
    String title,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Container(
      padding: ResponsiveSize.symmetric(h: 3, v: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: value ? Color(0xFF14B8A6) : Color(0xFFE2E8F0),
          width: value ? 2 : 1.5,
        ),
        borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
        color: value ? Color(0xFF14B8A6).withOpacity(0.05) : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF64748B).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: SizedBox(
              width: ResponsiveSize.w(6),
              height: ResponsiveSize.h(3),
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: Color(0xFF14B8A6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveSize.w(3)),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textDark,
                fontWeight: value ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
