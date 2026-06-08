import 'package:flutter/material.dart';
import '../../../data/model/medicine/medicine_model.dart';
import '../../../data/repository/authentication/authentication_repository.dart';
import '../../../data/repository/medicine/medicine_repository.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_datepicker.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../utils/constants/colors.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => AddMedicineScreenState();
}

class AddMedicineScreenState extends State<AddMedicineScreen> {
  final AuthRepository authRepository = AuthRepository();
  final MedicineRepository medicineRepository = MedicineRepository();

  final TextEditingController medicineNameController = TextEditingController();
  final TextEditingController medicineTypeController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  String? selectedMealTiming;
  bool isOngoing = false;
  bool isSaving = false;

  int frequencyCount = 0;
  List<String> selectedTimings = [];
  Map<String, TimeOfDay> reminderTimes = {};
  final List<String> availableTimings = [
    'Morning',
    'Afternoon',
    'Evening',
    'Night',
  ];

  static const Map<String, TimeOfDay> _defaultTimes = {
    'Morning': TimeOfDay(hour: 8, minute: 0),
    'Afternoon': TimeOfDay(hour: 13, minute: 0),
    'Evening': TimeOfDay(hour: 18, minute: 0),
    'Night': TimeOfDay(hour: 21, minute: 0),
  };

  void updateFrequencyCount(String frequency) {
    setState(() {
      if (frequency == 'Once a day') {
        frequencyCount = 1;
      } else if (frequency == 'Twice a day') {
        frequencyCount = 2;
      } else if (frequency == 'Thrice a day') {
        frequencyCount = 3;
      } else if (frequency == 'Four times a day') {
        frequencyCount = 4;
      }
      selectedTimings = [];
      reminderTimes = {};
    });
  }

  void selectTiming(String timing) {
    setState(() {
      if (selectedTimings.contains(timing)) {
        selectedTimings.remove(timing);
        reminderTimes.remove(timing);
      } else {
        if (selectedTimings.length < frequencyCount) {
          selectedTimings.add(timing);
          reminderTimes[timing] = _defaultTimes[timing]!;
        }
      }
    });
  }

  Future<void> pickTimeForTiming(String timing) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTimes[timing] ?? _defaultTimes[timing]!,
    );
    if (picked != null) {
      setState(() {
        reminderTimes[timing] = picked;
      });
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _displayTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> saveMedicine() async {
    if (medicineNameController.text.trim().isEmpty) {
      showErrorSnackBar('Please enter medicine name');
      return;
    }

    if (medicineTypeController.text.trim().isEmpty) {
      showErrorSnackBar('Please select medicine type');
      return;
    }

    if (dosageController.text.trim().isEmpty) {
      showErrorSnackBar('Please enter dosage');
      return;
    }

    if (frequencyController.text.trim().isEmpty) {
      showErrorSnackBar('Please select frequency');
      return;
    }

    if (selectedTimings.length != frequencyCount) {
      showErrorSnackBar('Please select $frequencyCount timing(s)');
      return;
    }

    if (startDate == null) {
      showErrorSnackBar('Please select start date');
      return;
    }

    if (!isOngoing && endDate == null) {
      showErrorSnackBar('Please select end date');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final uid = authRepository.currentUserId;

      if (uid.isEmpty) {
        showErrorSnackBar('User not authenticated');
        setState(() {
          isSaving = false;
        });
        return;
      }

      final medicine = MedicineModel(
        id: '',
        uid: uid,
        medicineName: medicineNameController.text.trim(),
        medicineType: medicineTypeController.text.trim(),
        dosage: dosageController.text.trim(),
        frequency: frequencyController.text.trim(),
        timings: selectedTimings,
        reminderTimes: reminderTimes.map(
          (timing, tod) => MapEntry(timing, _formatTime(tod)),
        ),
        mealTiming: selectedMealTiming,
        startDate: startDate!,
        endDate: isOngoing ? null : endDate,
        isOngoing: isOngoing,
        notes: notesController.text.trim().isNotEmpty
            ? notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      final medicineId = await medicineRepository.createMedicine(medicine);
      await medicineRepository.scheduleReminders(
        medicine.copyWith(id: medicineId),
      );

      setState(() {
        isSaving = false;
      });

      showSuccessSnackBar('Medicine added successfully');

      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      showErrorSnackBar('Failed to save medicine: ${e.toString()}');
      print('Error saving medicine: $e');
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
        backgroundColor: Colors.green,
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
      appBar: CustomAppBar(title: l10n.addMedicine),
      body: SingleChildScrollView(
        padding: ResponsiveSize.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hintText: l10n.medicineNameHint,
              labelText: l10n.medicineNameLabel,
              controller: medicineNameController,
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            CustomTextField(
              hintText: l10n.selectType,
              labelText: l10n.medicineTypeLabel,
              controller: medicineTypeController,
              readOnly: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.darkGreen,
              ),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.white,
                  context: context,
                  builder: (context) => Container(
                    padding: ResponsiveSize.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Tablet', 'Capsule', 'Syrup', 'Injection'].map(
                        (type) {
                          return ListTile(
                            title: Text(type),
                            onTap: () {
                              setState(() {
                                medicineTypeController.text = type;
                              });
                              Navigator.pop(context);
                            },
                          );
                        },
                      ).toList(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            CustomTextField(
              hintText: l10n.dosageHint,
              labelText: l10n.dosageLabel,
              controller: dosageController,
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            CustomTextField(
              hintText: l10n.selectFrequency,
              labelText: l10n.frequencyLabel,
              controller: frequencyController,
              readOnly: true,
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.darkGreen,
              ),
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: AppColors.white,
                  context: context,
                  builder: (context) => Container(
                    padding: ResponsiveSize.all(4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          [
                            'Once a day',
                            'Twice a day',
                            'Thrice a day',
                            'Four times a day',
                          ].map((freq) {
                            return ListTile(
                              title: Text(freq),
                              onTap: () {
                                setState(() {
                                  frequencyController.text = freq;
                                  updateFrequencyCount(freq);
                                });
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            if (frequencyCount > 0) ...[
              Text(
                'Select Timings * (Select $frequencyCount)',
                style: TextStyle(
                  fontSize: ResponsiveSize.font(14),
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(1)),
              Wrap(
                spacing: ResponsiveSize.w(2),
                runSpacing: ResponsiveSize.h(1),
                children: availableTimings.map((timing) {
                  final isSelected = selectedTimings.contains(timing);
                  return GestureDetector(
                    onTap: () => selectTiming(timing),
                    child: Container(
                      padding: ResponsiveSize.symmetric(h: 4, v: 1.5),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(2),
                        ),
                      ),
                      child: Text(
                        timing,
                        style: TextStyle(
                          fontSize: ResponsiveSize.font(14),
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textDark,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: ResponsiveSize.h(1.5)),

              // Time picker row for each selected timing
              if (selectedTimings.isNotEmpty) ...[
                Text(
                  'Set Reminder Times',
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(14),
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(1)),
                ...selectedTimings.map((timing) {
                  final time = reminderTimes[timing] ?? _defaultTimes[timing]!;
                  return Padding(
                    padding: EdgeInsets.only(bottom: ResponsiveSize.h(1)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            timing,
                            style: TextStyle(
                              fontSize: ResponsiveSize.font(14),
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => pickTimeForTiming(timing),
                          child: Container(
                            padding: ResponsiveSize.symmetric(h: 4, v: 1.5),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                              borderRadius:
                                  BorderRadius.circular(ResponsiveSize.w(2)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: ResponsiveSize.icon(1.8),
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: ResponsiveSize.w(1.5)),
                                Text(
                                  _displayTime(time),
                                  style: TextStyle(
                                    fontSize: ResponsiveSize.font(14),
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],

              SizedBox(height: ResponsiveSize.h(1)),
            ],

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMealTiming = 'Before Meal';
                      });
                    },
                    child: Container(
                      padding: ResponsiveSize.symmetric(h: 4, v: 2),
                      decoration: BoxDecoration(
                        color: selectedMealTiming == 'Before Meal'
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.white,
                        border: Border.all(
                          color: selectedMealTiming == 'Before Meal'
                              ? AppColors.primary
                              : AppColors.border,
                          width: selectedMealTiming == 'Before Meal' ? 2 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.beforeMeal,
                          style: TextStyle(
                            fontSize: ResponsiveSize.font(12),
                            color: selectedMealTiming == 'Before Meal'
                                ? AppColors.primary
                                : AppColors.textDark,
                            fontWeight: selectedMealTiming == 'Before Meal'
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveSize.w(3)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMealTiming = 'After Meal';
                      });
                    },
                    child: Container(
                      padding: ResponsiveSize.symmetric(h: 4, v: 2),
                      decoration: BoxDecoration(
                        color: selectedMealTiming == 'After Meal'
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.white,
                        border: Border.all(
                          color: selectedMealTiming == 'After Meal'
                              ? AppColors.primary
                              : AppColors.border,
                          width: selectedMealTiming == 'After Meal' ? 2 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          l10n.afterMeal,
                          style: TextStyle(
                            fontSize: ResponsiveSize.font(12),
                            color: selectedMealTiming == 'After Meal'
                                ? AppColors.primary
                                : AppColors.textDark,
                            fontWeight: selectedMealTiming == 'After Meal'
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            CustomDatePicker(
              initialDate: startDate,
              onDateSelected: (date) {
                setState(() {
                  startDate = date;
                });
              },
              hintText: l10n.selectStartDate,
              label: l10n.startDateLabel,
              lastDate: DateTime.now().add(const Duration(days: 365)),
              firstDate: DateTime.now(),
            ),
            SizedBox(height: ResponsiveSize.h(2)),

            Row(
              children: [
                Checkbox(
                  value: isOngoing,
                  onChanged: (value) {
                    setState(() {
                      isOngoing = value ?? false;
                      if (isOngoing) {
                        endDate = null;
                      }
                    });
                  },
                  activeColor: AppColors.lightGreen,
                ),
                Text(
                  l10n.ongoing,
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(14),
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.h(1)),

            if (!isOngoing)
              CustomDatePicker(
                initialDate: endDate,
                onDateSelected: (date) {
                  setState(() {
                    endDate = date;
                  });
                },
                hintText: l10n.selectEndDate,
                label: l10n.endDateLabel,
                firstDate: startDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ),
            SizedBox(height: ResponsiveSize.h(2)),

            CustomTextField(
              hintText: l10n.additionalInstructions,
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
                text: isSaving ? l10n.savingMedicine : l10n.saveMedicine,
                backgroundColor: Colors.transparent,
                textColor: AppColors.white,
                onPressed: isSaving ? () {} : saveMedicine,
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

  @override
  void dispose() {
    medicineNameController.dispose();
    medicineTypeController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
