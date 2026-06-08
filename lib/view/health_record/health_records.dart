import 'package:flutter/material.dart';
import 'package:sehatalert/view/health_record/widgets/add_diabetes_record.dart';
import 'package:sehatalert/view/health_record/widgets/add_heart_record.dart';
import 'package:sehatalert/view/health_record/widgets/add_hypertension_record.dart';
import 'package:sehatalert/view/health_record/widgets/record_card.dart';
import '../../data/model/health_record/health_record_model.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/health_record/health_record_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/shimmer_effect.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/exceptions/exceptions.dart';

class HealthRecordsScreen extends StatefulWidget {
  const HealthRecordsScreen({super.key});

  @override
  State<HealthRecordsScreen> createState() => HealthRecordsScreenState();
}

class HealthRecordsScreenState extends State<HealthRecordsScreen>
    with SingleTickerProviderStateMixin {
  final AuthRepository authRepository = AuthRepository();
  final HealthRecordRepository healthRecordRepository =
      HealthRecordRepository();

  List<String> userDiseases = [];
  bool isLoading = true;
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    loadUserDiseases();
  }

  Future<void> loadUserDiseases() async {
    try {
      final userData = await authRepository.getCurrentUserData();

      if (userData != null && userData.patientInfo != null) {
        setState(() {
          userDiseases = userData.patientInfo!.diseases;
          if (userDiseases.isNotEmpty) {
            tabController = TabController(
              length: userDiseases.length,
              vsync: this,
            );
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorSnackBar('Error loading user diseases: ${e.toString()}');
    }
  }

  String getDiseaseDisplayName(String disease) {
    switch (disease) {
      case 'Diabetes':
        return 'Diabetes';
      case 'Heart Disease':
        return 'Heart';
      case 'Hypertension':
        return 'Hypertension';
      default:
        return disease;
    }
  }

  void navigateToAddScreen(String diseaseType) async {
    Widget? screen;
    switch (diseaseType) {
      case 'Diabetes':
        screen = const AddDiabetesRecordScreen();
        break;
      case 'Heart Disease':
        screen = const AddHeartRecordScreen();
        break;
      case 'Hypertension':
        screen = const AddHypertensionRecordScreen();
        break;
      default:
        return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen!),
    );

    if (result == true) {
      setState(() {});
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

  Future<void> handleDeleteRecord(String recordId) async {
    try {
      await healthRecordRepository.deleteHealthRecord(
        authRepository.currentUserId,
        recordId,
      );
      showSuccessSnackBar('Record deleted successfully');
      setState(() {});
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to delete record');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightWhite,
        appBar: CustomAppBar(title: l10n.healthRecords),
        body: Padding(
          padding: ResponsiveSize.all(4),
          child: Column(
            children: [
              Container(
                height: ResponsiveSize.h(6),
                padding: ResponsiveSize.symmetric(h: 4, v: 2),
                child: Row(
                  children: [
                    ShimmerEffect(
                      width: ResponsiveSize.w(20),
                      height: ResponsiveSize.h(3),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                    SizedBox(width: ResponsiveSize.w(4)),
                    ShimmerEffect(
                      width: ResponsiveSize.w(20),
                      height: ResponsiveSize.h(3),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                    SizedBox(width: ResponsiveSize.w(4)),
                    ShimmerEffect(
                      width: ResponsiveSize.w(20),
                      height: ResponsiveSize.h(3),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: ResponsiveSize.only(bottom: 2),
                      padding: ResponsiveSize.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShimmerEffect(
                                width: ResponsiveSize.w(12),
                                height: ResponsiveSize.w(12),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(2),
                                ),
                              ),
                              SizedBox(width: ResponsiveSize.w(4)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ShimmerEffect(
                                      width: ResponsiveSize.w(30),
                                      height: ResponsiveSize.h(2),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.w(1),
                                      ),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(1)),
                                    ShimmerEffect(
                                      width: ResponsiveSize.w(50),
                                      height: ResponsiveSize.h(1.5),
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveSize.w(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          ShimmerEffect(
                            width: double.infinity,
                            height: ResponsiveSize.h(1.5),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (userDiseases.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.lightWhite,
        appBar: CustomAppBar(title: l10n.healthRecords),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.health_and_safety_outlined,
                size: ResponsiveSize.icon(10),
                color: AppColors.textGray,
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              Text(
                l10n.noDiseases,
                style: TextStyle(
                  fontSize: ResponsiveSize.font(16),
                  color: AppColors.textGray,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(1)),
              Text(
                l10n.updateProfileForDiseases,
                style: TextStyle(
                  fontSize: ResponsiveSize.font(12),
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      appBar: CustomAppBar(title: l10n.healthRecords),
      body: Column(
        children: [
          Container(
            color: AppColors.white,
            child: TabBar(
              controller: tabController,
              labelColor: AppColors.darkGreen,
              unselectedLabelColor: AppColors.textGray,
              indicatorColor: AppColors.darkGreen,
              indicatorWeight: 3,
              labelStyle: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: AppTextStyles.bodyMedium,
              tabs: userDiseases.map((disease) {
                return Tab(text: getDiseaseDisplayName(disease));
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: userDiseases.map((disease) {
                return DiseaseRecordsTab(
                  diseaseType: disease,
                  userId: authRepository.currentUserId,
                  healthRecordRepository: healthRecordRepository,
                  onAddRecord: () => navigateToAddScreen(disease),
                  onDeleteRecord: handleDeleteRecord,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}

class DiseaseRecordsTab extends StatelessWidget {
  final String diseaseType;
  final String userId;
  final HealthRecordRepository healthRecordRepository;
  final VoidCallback onAddRecord;
  final Function(String) onDeleteRecord;

  const DiseaseRecordsTab({
    super.key,
    required this.diseaseType,
    required this.userId,
    required this.healthRecordRepository,
    required this.onAddRecord,
    required this.onDeleteRecord,
  });

  IconData getIconByType() {
    switch (diseaseType) {
      case 'Diabetes':
        return Icons.water_drop;
      case 'Heart Disease':
        return Icons.favorite;
      case 'Hypertension':
        return Icons.monitor_heart;
      default:
        return Icons.health_and_safety;
    }
  }

  Color getColorByType() {
    switch (diseaseType) {
      case 'Diabetes':
        return Colors.blue;
      case 'Heart Disease':
        return Colors.red;
      case 'Hypertension':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  String getReadingText(HealthRecordModel record) {
    switch (diseaseType) {
      case 'Diabetes':
        return '${record.readings['bloodSugar']} mg/dL';
      case 'Heart Disease':
        return '${record.readings['heartRate']} bpm';
      case 'Hypertension':
        return '${record.readings['systolic']}/${record.readings['diastolic']}';
      default:
        return '';
    }
  }

  String getAdditionalInfo(HealthRecordModel record) {
    switch (diseaseType) {
      case 'Diabetes':
        return record.readings['readingType'] ?? '';
      case 'Heart Disease':
        return record.readings['symptoms'] ?? '';
      case 'Hypertension':
        return 'Systolic: ${record.readings['systolic']}, Diastolic: ${record.readings['diastolic']}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<List<HealthRecordModel>>(
      stream: healthRecordRepository.getHealthRecordsByDiseaseStream(
        userId,
        diseaseType,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: ResponsiveSize.all(4),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: ResponsiveSize.only(bottom: 2),
                  padding: ResponsiveSize.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ShimmerEffect(
                            width: ResponsiveSize.w(12),
                            height: ResponsiveSize.w(12),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(2),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(4)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShimmerEffect(
                                  width: ResponsiveSize.w(30),
                                  height: ResponsiveSize.h(2),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(1),
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.h(1)),
                                ShimmerEffect(
                                  width: ResponsiveSize.w(50),
                                  height: ResponsiveSize.h(1.5),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ResponsiveSize.h(2)),
                      ShimmerEffect(
                        width: double.infinity,
                        height: ResponsiveSize.h(1.5),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(1),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveSize.icon(8),
                  color: Colors.red,
                ),
                SizedBox(height: ResponsiveSize.h(2)),
                Text(
                  l10n.errorLoadingRecords,
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(14),
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        }

        final records = snapshot.data ?? [];

        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  getIconByType(),
                  size: ResponsiveSize.icon(4.5),
                  color: getColorByType(),
                ),
                SizedBox(height: ResponsiveSize.h(1)),
                Text(
                  l10n.noRecordsAdded,
                  style: TextStyle(
                    fontSize: ResponsiveSize.font(16),
                    color: AppColors.textGray,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(1)),
                ElevatedButton.icon(
                  onPressed: onAddRecord,
                  icon: Icon(Icons.add, size: ResponsiveSize.icon(2)),
                  label: Text(l10n.addRecord),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: getColorByType(),
                    foregroundColor: Colors.white,
                    padding: ResponsiveSize.symmetric(h: 4, v: .5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(2)),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              padding: ResponsiveSize.all(4),
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return HealthRecordCard(
                  diseaseType: diseaseType == 'Heart Disease'
                      ? 'Heart'
                      : diseaseType,
                  reading: getReadingText(record),
                  dateTime:
                      '${record.date.day} ${getMonthName(record.date.month)} ${record.date.year}, ${record.time}',
                  additionalInfo: getAdditionalInfo(record),
                  onEdit: onAddRecord,
                  onDelete: () => onDeleteRecord(record.id),
                );
              },
            ),
            Positioned(
              bottom: ResponsiveSize.h(2),
              right: ResponsiveSize.w(4),
              child: FloatingActionButton(
                onPressed: onAddRecord,
                backgroundColor: getColorByType(),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
