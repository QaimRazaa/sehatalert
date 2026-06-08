import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/shared_pref/shared_pref.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/contact/contact_repository.dart';
import '../../data/repository/health_record/health_record_repository.dart';
import '../../data/repository/medicine/medicine_repository.dart';
import '../../shared/widgets/section_container.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../signin/signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthRepository authRepository = AuthRepository();
  bool isLoading = true;

  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String dateOfBirth = "";
  String gender = "";
  String bloodGroup = "";
  String height = "";
  String weight = "";
  String city = "";

  List<String> diseases = [];
  List<String> allergies = [];
  int totalMedicines = 0;
  int totalRecords = 0;
  int totalContacts = 0;
  List<String> medicines = [];

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
          userName = userData.fullName;
          userEmail = userData.email;
          userPhone = userData.phoneNumber;

          if (userData.patientInfo != null) {
            final patientInfo = userData.patientInfo!;

            dateOfBirth = DateFormat(
              'd MMM yyyy',
            ).format(patientInfo.dateOfBirth);
            gender = patientInfo.gender;
            bloodGroup = patientInfo.bloodGroup ?? "N/A";
            height = patientInfo.height != null
                ? "${patientInfo.height} cm"
                : "N/A";
            weight = patientInfo.weight != null
                ? "${patientInfo.weight} kg"
                : "N/A";
            city = patientInfo.city ?? "N/A";

            diseases = patientInfo.diseases;

            allergies = patientInfo.allergies
                .split(',')
                .map((e) => e.trim())
                .toList();
          }
        });

        await _loadContactsCount();
        await _loadMedicinesData();
        await _loadHealthRecordsCount();

        setState(() {
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
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadContactsCount() async {
    try {
      final contactRepository = ContactRepository();
      final contacts = await contactRepository.getAllContacts(
        authRepository.currentUserId,
      );
      setState(() {
        totalContacts = contacts.length;
      });
    } catch (e) {
      print('Error loading contacts count: $e');
    }
  }

  Future<void> _loadMedicinesData() async {
    try {
      final medicineRepository = MedicineRepository();
      final medicinesList = await medicineRepository.getUserMedicines(
        authRepository.currentUserId,
      );

      setState(() {
        totalMedicines = medicinesList.length;
        medicines = medicinesList
            .map((m) => '${m.medicineName} ${m.dosage}')
            .toList();
      });
    } catch (e) {
      print('Error loading medicines: $e');
    }
  }

  Future<void> _loadHealthRecordsCount() async {
    try {
      final userData = await authRepository.getCurrentUserData();
      final healthRecordRepository = HealthRecordRepository();
      int count = 0;

      if (userData != null && userData.patientInfo != null) {
        for (String disease in userData.patientInfo!.diseases) {
          final records = await healthRecordRepository
              .getHealthRecordsByDisease(authRepository.currentUserId, disease);
          count += records.length;
        }
      }

      setState(() {
        totalRecords = count;
      });
    } catch (e) {
      print('Error loading health records count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.lightGreen,
                      AppColors.lightGreen.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: ResponsiveSize.h(8)),
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: CircleAvatar(
                        radius: ResponsiveSize.w(8),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(
                        width: ResponsiveSize.w(40),
                        height: ResponsiveSize.h(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(0.5)),
                    Shimmer.fromColors(
                      baseColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.5),
                      child: Container(
                        width: ResponsiveSize.w(50),
                        height: ResponsiveSize.h(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(3)),
                    Padding(
                      padding: ResponsiveSize.symmetric(h: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.white.withOpacity(0.4),
                              child: Container(
                                padding: ResponsiveSize.symmetric(v: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                height: ResponsiveSize.h(8),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(3)),
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.white.withOpacity(0.4),
                              child: Container(
                                padding: ResponsiveSize.symmetric(v: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                height: ResponsiveSize.h(8),
                              ),
                            ),
                          ),
                          SizedBox(width: ResponsiveSize.w(3)),
                          Expanded(
                            child: Shimmer.fromColors(
                              baseColor: Colors.white.withOpacity(0.2),
                              highlightColor: Colors.white.withOpacity(0.4),
                              child: Container(
                                padding: ResponsiveSize.symmetric(v: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                height: ResponsiveSize.h(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(3)),
                  ],
                ),
              ),
              Padding(
                padding: ResponsiveSize.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: ResponsiveSize.w(40),
                              height: ResponsiveSize.h(2.5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          ...List.generate(3, (index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: ResponsiveSize.h(2),
                              ),
                              child: Row(
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: CircleAvatar(
                                      radius: ResponsiveSize.icon(1.25),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(3)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: ResponsiveSize.w(25),
                                          height: ResponsiveSize.h(1.5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveSize.w(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: ResponsiveSize.h(0.5)),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: ResponsiveSize.w(35),
                                          height: ResponsiveSize.h(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              ResponsiveSize.w(0.5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1)),
                    SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: ResponsiveSize.w(30),
                              height: ResponsiveSize.h(2.5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          Row(
                            children: List.generate(3, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: index < 2 ? ResponsiveSize.w(3) : 0,
                                  ),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      padding: ResponsiveSize.all(3),
                                      height: ResponsiveSize.h(15),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          ResponsiveSize.w(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1)),
                    SectionContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: ResponsiveSize.w(40),
                              height: ResponsiveSize.h(2.5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          Wrap(
                            spacing: ResponsiveSize.w(2),
                            runSpacing: ResponsiveSize.h(1),
                            children: List.generate(2, (index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: ResponsiveSize.w(25),
                                  height: ResponsiveSize.h(3.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveSize.w(5),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(3)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lightGreen,
                    AppColors.lightGreen.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: ResponsiveSize.h(8)),
                  CircleAvatar(
                    radius: ResponsiveSize.w(8),
                    backgroundColor: AppColors.white,
                    child: Icon(
                      Icons.person,
                      size: ResponsiveSize.icon(4),
                      color: AppColors.lightGreen,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  Text(
                    userName,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(0.5)),
                  Text(
                    userEmail,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(3)),
                  Padding(
                    padding: ResponsiveSize.symmetric(h: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            padding: ResponsiveSize.symmetric(v: 2),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  totalMedicines.toString(),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l10n.medicines,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(3)),
                        Expanded(
                          child: Container(
                            padding: ResponsiveSize.symmetric(v: 2),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  totalRecords.toString(),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l10n.records,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(3)),
                        Expanded(
                          child: Container(
                            padding: ResponsiveSize.symmetric(v: 2),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  totalContacts.toString(),
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l10n.contacts,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(3)),
                ],
              ),
            ),
            Padding(
              padding: ResponsiveSize.all(4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.personalInformation,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Row(
                          children: [
                            Icon(
                              Icons.phone,
                              color: AppColors.lightGreen,
                              size: ResponsiveSize.icon(2.5),
                            ),
                            SizedBox(width: ResponsiveSize.w(3)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.phoneNumber,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textGray,
                                  ),
                                ),
                                Text(
                                  userPhone,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Row(
                          children: [
                            Icon(
                              Icons.cake,
                              color: AppColors.lightGreen,
                              size: ResponsiveSize.icon(2.5),
                            ),
                            SizedBox(width: ResponsiveSize.w(3)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.dateOfBirth,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textGray,
                                  ),
                                ),
                                Text(
                                  dateOfBirth,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: AppColors.lightGreen,
                                    size: ResponsiveSize.icon(2.5),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(3)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.gender,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                      Text(
                                        gender,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.textDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_city,
                                    color: AppColors.lightGreen,
                                    size: ResponsiveSize.icon(2.5),
                                  ),
                                  SizedBox(width: ResponsiveSize.w(3)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.city,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.textGray,
                                        ),
                                      ),
                                      Text(
                                        city,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.textDark,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),

                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.healthMetrics,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: ResponsiveSize.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.water_drop,
                                      color: Colors.red,
                                      size: ResponsiveSize.icon(4),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(1)),
                                    Text(
                                      bloodGroup,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      l10n.bloodGroup,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.w(3)),
                            Expanded(
                              child: Container(
                                padding: ResponsiveSize.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.height,
                                      color: Colors.blue,
                                      size: ResponsiveSize.icon(4),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(1)),
                                    Text(
                                      height,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      l10n.height,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: ResponsiveSize.w(3)),
                            Expanded(
                              child: Container(
                                padding: ResponsiveSize.all(3),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveSize.w(2),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.monitor_weight,
                                      color: Colors.orange,
                                      size: ResponsiveSize.icon(4),
                                    ),
                                    SizedBox(height: ResponsiveSize.h(1)),
                                    Text(
                                      weight,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      l10n.weight,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),

                  SectionContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.medicalConditions,
                          style: AppTextStyles.titleSmall.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Wrap(
                          spacing: ResponsiveSize.w(2),
                          runSpacing: ResponsiveSize.h(1),
                          children: diseases.map((disease) {
                            return Container(
                              padding: ResponsiveSize.symmetric(h: 3, v: 1),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(5),
                                ),
                                border: Border.all(
                                  color: AppColors.lightGreen,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                disease,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.lightGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Divider(color: AppColors.border),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Text(
                          l10n.knownAllergies,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(1)),
                        Wrap(
                          spacing: ResponsiveSize.w(2),
                          runSpacing: ResponsiveSize.h(1),
                          children: allergies.map((allergy) {
                            return Container(
                              padding: ResponsiveSize.symmetric(h: 3, v: 1),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(
                                  ResponsiveSize.w(5),
                                ),
                              ),
                              child: Text(
                                allergy,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Divider(color: AppColors.border),
                        SizedBox(height: ResponsiveSize.h(2)),
                        Text(
                          l10n.currentMedicines,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(1)),
                        Text(
                          medicines.isEmpty
                              ? l10n.noMedicinesAdded
                              : medicines.join(', '),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),

                  SectionContainer(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.red.withOpacity(0.1),
                            child: Icon(Icons.logout, color: Colors.red),
                          ),
                          title: Text(
                            l10n.logout,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: ResponsiveSize.icon(2),
                            color: AppColors.textGray,
                          ),
                          onTap: () async {
                            try {
                              await SharedPreferencesService()
                                  .clearCredentials();

                              await authRepository.signOut();

                              if (mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error logging out: ${e.toString()}',
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
