// lib/view/medicine/my_medicine_screen.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sehatalert/view/medicine/widgets/add_medicine.dart';
import 'package:sehatalert/view/medicine/widgets/medicine_card.dart';
import '../../data/model/medicine/medicine_model.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/medicine/medicine_repository.dart';
import '../../data/services/notification/notification_service.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../utils/constants/colors.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';

class MyMedicineScreen extends StatefulWidget {
  const MyMedicineScreen({super.key});

  @override
  State<MyMedicineScreen> createState() => _MyMedicineScreenState();
}

class _MyMedicineScreenState extends State<MyMedicineScreen> {
  final AuthRepository authRepository = AuthRepository();
  final MedicineRepository medicineRepository = MedicineRepository();

  List<MedicineModel> medicines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final uid = authRepository.currentUserId;

      print('=== Loading Medicines ===');
      print('Current User ID: $uid');

      if (uid.isEmpty) {
        print('ERROR: User ID is empty!');
        setState(() {
          isLoading = false;
        });
        return;
      }

      final medicinesList = await medicineRepository.getUserMedicines(uid);

      print('Medicines found: ${medicinesList.length}');
      for (var medicine in medicinesList) {
        print('Medicine: ${medicine.medicineName}, UID: ${medicine.uid}');
      }

      setState(() {
        medicines = medicinesList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading medicines: $e');
    }
  }

  Future<void> _deleteMedicine(String medicineId, int index) async {
    try {
      await NotificationService().cancelRemindersForMedicine(
        medicineId,
        medicines[index].reminderTimes.length,
      );
      await medicineRepository.deleteMedicine(medicineId);

      setState(() {
        medicines.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medicine deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete medicine'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      print('Error deleting medicine: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightWhite,
        appBar: CustomAppBar(title: l10n.myMedicine),
        body: ListView.builder(
          padding: ResponsiveSize.all(4),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: ResponsiveSize.h(2)),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  padding: ResponsiveSize.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: ResponsiveSize.w(12),
                            height: ResponsiveSize.w(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(2),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(3)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: ResponsiveSize.w(40),
                                  height: ResponsiveSize.h(2.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.w(1),
                                    ),
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.h(1)),
                                Container(
                                  width: ResponsiveSize.w(30),
                                  height: ResponsiveSize.h(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.w(1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: ResponsiveSize.w(8),
                            height: ResponsiveSize.w(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(2)),
                          Container(
                            width: ResponsiveSize.w(8),
                            height: ResponsiveSize.w(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(2)),
                      Container(
                        width: ResponsiveSize.w(50),
                        height: ResponsiveSize.h(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      appBar: CustomAppBar(
        title: l10n.myMedicine,
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicineScreen(),
                ),
              );

              if (result == true) {
                _loadMedicines();
              }
            },
            icon: Icon(
              Icons.add,
              color: AppColors.primary,
              size: ResponsiveSize.icon(3),
            ),
          ),
        ],
      ),
      body: medicines.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: ResponsiveSize.icon(10),
                    color: AppColors.textGray,
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  Text(
                    "No medicines added yet",
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(16),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),
                  Text(
                    "Tap + to add your first medicine",
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: ResponsiveSize.all(4),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                return MedicineCard(
                  medicineName: medicine.medicineName,
                  dosage: medicine.dosage,
                  frequency: medicine.frequency,
                  onEdit: () {
                    // TODO: Implement edit functionality
                  },
                  onDelete: () => _deleteMedicine(medicine.id, index),
                );
              },
            ),
    );
  }
}
