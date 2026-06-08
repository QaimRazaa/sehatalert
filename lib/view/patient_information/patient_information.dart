// lib/views/patient_information/patient_information.dart

import 'package:flutter/material.dart';
import 'package:sehatalert/view/patient_information/widgets/blood_group.dart';
import 'package:sehatalert/view/patient_information/widgets/gender_picker.dart';
import 'package:sehatalert/view/patient_information/widgets/height_picker.dart';
import 'package:sehatalert/view/patient_information/widgets/weight_picker.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_datepicker.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../shared/widgets/section_container.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/validators/validators.dart';
import '../../utils/formatters/formatters.dart';
import '../disease_selection/disease_selection.dart';

class PatientInformation extends StatefulWidget {
  const PatientInformation({super.key});

  @override
  State<PatientInformation> createState() => _PatientInformationState();
}

class _PatientInformationState extends State<PatientInformation> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();

  DateTime? selectedDateOfBirth;
  bool isLoading = true;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController knownAllergiesController =
      TextEditingController();

  final TextEditingController emergency1NameController =
      TextEditingController();
  final TextEditingController emergency1RelationController =
      TextEditingController();
  final TextEditingController emergency1PhoneController =
      TextEditingController();

  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await authRepository.getCurrentUserData();

      if (userData != null) {
        setState(() {
          fullNameController.text = userData.fullName;
          mobileController.text = userData.phoneNumber;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showErrorSnackBar('Failed to load user data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorSnackBar('Error loading user data: ${e.toString()}');
    }
  }

  void handleSaveAndContinue() {
    if (!formKey.currentState!.validate()) {
      showErrorSnackBar('Please fill all required fields');
      return;
    }

    if (selectedDateOfBirth == null) {
      showErrorSnackBar('Please select date of birth');
      return;
    }

    if (genderController.text.isEmpty) {
      showErrorSnackBar('Please select gender');
      return;
    }

    // Navigate to disease selection and pass data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseSelection(
          patientData: {
            'fullName': fullNameController.text.trim(),
            'mobile': mobileController.text.trim(),
            'dateOfBirth': selectedDateOfBirth!,
            'gender': genderController.text,
            'bloodGroup': bloodGroupController.text.isNotEmpty
                ? bloodGroupController.text
                : null,
            'allergies': knownAllergiesController.text.trim(),
            'emergencyContact': {
              'name': emergency1NameController.text.trim(),
              'relationship': emergency1RelationController.text.trim(),
              'phoneNumber': emergency1PhoneController.text.trim(),
            },
            'height': heightController.text.isNotEmpty
                ? heightController.text
                : null,
            'weight': weightController.text.isNotEmpty
                ? weightController.text
                : null,
            'city': cityController.text.isNotEmpty
                ? cityController.text.trim()
                : null,
          },
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF8FAFC),
        appBar: CustomAppBar(title: l10n.patientInformation),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.darkGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: CustomAppBar(title: l10n.patientInformation),
      body: SingleChildScrollView(
        padding: ResponsiveSize.all(3),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(l10n.basicDetails),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.enterFullName,
                      labelText: l10n.fullNameLabel,
                      controller: fullNameController,
                      readOnly: true,
                      enabled: false,
                      inputFormatters: AppFormatters.nameFormatter(),
                      validator: Validators.validateFullName,
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.enterMobileNumber,
                      labelText: l10n.mobileNumberLabel,
                      controller: mobileController,
                      readOnly: true,
                      enabled: false,
                      keyboardType: TextInputType.phone,
                      inputFormatters: AppFormatters.phoneNumberFormatter(),
                      validator: Validators.validatePhoneNumber,
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomDatePicker(
                      initialDate: selectedDateOfBirth,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDateOfBirth = date;
                        });
                      },
                      hintText: l10n.selectDateOfBirth,
                      label: l10n.dateOfBirthLabel,
                      lastDate: DateTime.now(),
                      firstDate: DateTime(1900),
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.selectGender,
                      labelText: l10n.genderLabel,
                      controller: genderController,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.darkGreen,
                      ),
                      onTap: () {
                        GenderPicker.show(
                          context: context,
                          onSelected: (value) {
                            setState(() {
                              genderController.text = value;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              SectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(l10n.healthAndSafety),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.bloodGroupHint,
                      labelText: l10n.bloodGroupLabel,
                      controller: bloodGroupController,
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.darkGreen,
                      ),
                      onTap: () {
                        BloodGroupPicker.show(
                          context: context,
                          onSelected: (value) {
                            setState(() {
                              bloodGroupController.text = value;
                            });
                          },
                        );
                      },
                    ),

                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.listAllergies,
                      labelText: l10n.knownAllergiesLabel,
                      controller: knownAllergiesController,
                      maxLines: 3,
                      validator: (value) =>
                          Validators.validateRequired(value, 'Known allergies'),
                    ),
                  ],
                ),
              ),

              SectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(l10n.emergencyInformation),
                    SizedBox(height: ResponsiveSize.h(2)),

                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                      ).createShader(bounds),
                      child: Text(
                        l10n.emergencyContact1,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1.5)),

                    CustomTextField(
                      hintText: l10n.enterContactName,
                      labelText: l10n.contactNameLabel,
                      controller: emergency1NameController,
                      inputFormatters: AppFormatters.nameFormatter(),
                      validator: Validators.validateFullName,
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.relationshipHint,
                      labelText: l10n.relationshipLabel,
                      controller: emergency1RelationController,
                      validator: (value) =>
                          Validators.validateRequired(value, 'Relationship'),
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.enterPhoneNumber,
                      labelText: l10n.phoneNumberLabel,
                      controller: emergency1PhoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: AppFormatters.phoneNumberFormatter(),
                      validator: Validators.validatePhoneNumber,
                    ),
                  ],
                ),
              ),

              SectionContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(l10n.optionalDetails),
                    SizedBox(height: ResponsiveSize.h(2)),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: l10n.heightHint,
                            labelText: l10n.heightLabel,
                            controller: heightController,
                            readOnly: true,
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.darkGreen,
                            ),
                            onTap: () {
                              HeightPicker.show(
                                context: context,
                                onSelected: (value) {
                                  setState(() {
                                    heightController.text = value;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(3)),
                        Expanded(
                          child: CustomTextField(
                            hintText: l10n.weightHint,
                            labelText: l10n.weightLabel,
                            controller: weightController,
                            readOnly: true,
                            suffixIcon: Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.darkGreen,
                            ),
                            onTap: () {
                              WeightPicker.show(
                                context: context,
                                onSelected: (value) {
                                  setState(() {
                                    weightController.text = value;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ResponsiveSize.h(2)),

                    CustomTextField(
                      hintText: l10n.enterCityName,
                      labelText: l10n.cityLabel,
                      controller: cityController,
                    ),
                  ],
                ),
              ),

              SizedBox(height: ResponsiveSize.h(2)),
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
                  text: l10n.saveAndContinue,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                  onPressed: handleSaveAndContinue,
                  width: ResponsiveSize.w(25),
                  height: ResponsiveSize.h(.6),
                  borderRadius: 5,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
      ).createShader(bounds),
      child: Text(
        title,
        style: AppTextStyles.titleMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileController.dispose();
    genderController.dispose();
    bloodGroupController.dispose();
    knownAllergiesController.dispose();
    emergency1NameController.dispose();
    emergency1RelationController.dispose();
    emergency1PhoneController.dispose();
    heightController.dispose();
    weightController.dispose();
    cityController.dispose();
    super.dispose();
  }
}
