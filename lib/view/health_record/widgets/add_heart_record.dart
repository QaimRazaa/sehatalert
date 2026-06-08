import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/health_record/health_record_model.dart';
import '../../../data/repository/authentication/authentication_repository.dart';
import '../../../data/repository/health_record/health_record_repository.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_datepicker.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../utils/constants/colors.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';
import '../../../utils/exceptions/exceptions.dart';

class AddHeartRecordScreen extends StatefulWidget {
  const AddHeartRecordScreen({super.key});

  @override
  State<AddHeartRecordScreen> createState() => AddHeartRecordScreenState();
}

class AddHeartRecordScreenState extends State<AddHeartRecordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final HealthRecordRepository healthRecordRepository =
      HealthRecordRepository();

  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? selectedDate;
  bool isLoading = false;

  Future<void> handleSaveRecord() async {
    if (!formKey.currentState!.validate()) {
      showErrorSnackBar('Please fill all required fields');
      return;
    }

    if (selectedDate == null) {
      showErrorSnackBar('Please select date');
      return;
    }

    if (timeController.text.isEmpty) {
      showErrorSnackBar('Please select time');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final recordId = const Uuid().v4();
      final userId = authRepository.currentUserId;

      final healthRecord = HealthRecordModel(
        id: recordId,
        userId: userId,
        diseaseType: 'Heart Disease',
        date: selectedDate!,
        time: timeController.text.trim(),
        readings: {
          'heartRate': heartRateController.text.trim(),
          'symptoms': symptomsController.text.trim(),
        },
        notes: notesController.text.trim().isNotEmpty
            ? notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      await healthRecordRepository.createHealthRecord(healthRecord);

      if (mounted) {
        showSuccessSnackBar('Record saved successfully');
        Navigator.pop(context, true);
      }
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to save record. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      backgroundColor: AppColors.lightWhite,
      appBar: CustomAppBar(title: l10n.addHeartRecord),
      body: SingleChildScrollView(
        padding: ResponsiveSize.all(4),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                hintText: l10n.heartRateHint,
                labelText: l10n.heartRateLabel,
                controller: heartRateController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Heart rate is required';
                  }
                  final number = int.tryParse(value.trim());
                  if (number == null) {
                    return 'Please enter a valid number';
                  }
                  if (number < 30 || number > 250) {
                    return 'Please enter a valid heart rate';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomDatePicker(
                initialDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
                hintText: l10n.selectDate,
                label: l10n.dateLabel,
                lastDate: DateTime.now(),
                firstDate: DateTime(2020),
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.timeHint,
                labelText: l10n.timeLabel,
                controller: timeController,
                readOnly: true,
                suffixIcon: Icon(Icons.access_time, color: AppColors.darkGreen),
                onTap: () async {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    setState(() {
                      timeController.text = time.format(context);
                    });
                  }
                },
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.describeSymptoms,
                labelText: l10n.symptomsLabel,
                controller: symptomsController,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Symptoms are required';
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              GestureDetector(
                onTap: () {
                  showErrorSnackBar('File upload feature coming soon');
                },
                child: Container(
                  padding: ResponsiveSize.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: AppColors.lightGreen,
                        size: ResponsiveSize.icon(3),
                      ),
                      SizedBox(width: ResponsiveSize.w(3)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.uploadEcgReports,
                              style: TextStyle(
                                fontSize: ResponsiveSize.font(12),
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(0.5)),
                            Text(
                              l10n.tapToSelectFile,
                              style: TextStyle(
                                fontSize: ResponsiveSize.font(11),
                                color: AppColors.textGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.anyAdditionalNotes,
                labelText: l10n.notesOptionalLabel,
                controller: notesController,
                maxLines: 4,
              ),
              SizedBox(height: ResponsiveSize.h(3)),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CustomElevatedButton(
                  text: isLoading ? l10n.savingRecord : l10n.saveRecord,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                  onPressed: isLoading ? null : handleSaveRecord,
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

  @override
  void dispose() {
    heartRateController.dispose();
    timeController.dispose();
    symptomsController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
