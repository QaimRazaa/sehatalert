import 'package:flutter/material.dart';
import 'package:sehatalert/data/services/voice/voice_sevice.dart';
import 'package:sehatalert/data/services/location/location_service.dart';
import 'package:sehatalert/view/health_record/health_records.dart';
import 'package:sehatalert/view/home/widgets/action_card.dart';
import 'package:sehatalert/view/labs/my_labs.dart';
import 'package:sehatalert/view/medicine/my_medicine.dart';
import 'package:sehatalert/view/pharmacy/my_pharmacy.dart';
import 'package:sehatalert/view/profile/my_profile.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/shimmer_effect.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../contacts/my_contacts.dart';
import 'package:sehatalert/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  bool isLoading = true;
  bool isRecording = false;
  bool isProcessing = false;

  final VoiceRecorderService _voiceService = VoiceRecorderService();
  final AuthRepository _authRepository = AuthRepository();
  final LocationService _locationService = LocationService();
  bool _isSendingEmergency = false;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }

  Widget _buildRecordingBar() {
    return Container(
      padding: ResponsiveSize.symmetric(h: 5, v: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              width: ResponsiveSize.w(3),
              height: ResponsiveSize.w(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: ResponsiveSize.w(3)),
            Expanded(
              child: Text(
                'Recording...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            GestureDetector(
              onTap: _stopAndProcess,
              child: Container(
                width: ResponsiveSize.w(12),
                height: ResponsiveSize.w(12),
                decoration: BoxDecoration(
                  color: AppColors.darkGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.darkGreen.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.icon(2.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadUserName() async {
    final userData = await _authRepository.getCurrentUserData();
    if (mounted) {
      setState(() {
        if (userData != null) {
          userName = userData.fullName.split(' ').first;
        }
        isLoading = false;
      });
    }
  }

  Future<void> _startRecording() async {
    final granted = await _voiceService.requestMicPermission();
    if (!granted) {
      _showErrorSnackBar(
        'Microphone permission denied. Please enable it in Settings.',
      );
      return;
    }
    try {
      await _voiceService.startRecording();
      if (mounted) setState(() => isRecording = true);
    } catch (e) {
      _showErrorSnackBar('Failed to start recording');
    }
  }

  Future<void> _stopAndProcess() async {
    if (!isRecording) return;
    if (mounted) {
      setState(() {
        isRecording = false;
        isProcessing = true;
      });
    }
    try {
      final uid = _authRepository.currentUserId;
      await _voiceService.stopAndProcess(uid);
      _showSuccessSnackBar('Voice note sent successfully ✓');
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  Future<void> _triggerEmergency() async {
    if (_isSendingEmergency) return;
    setState(() => _isSendingEmergency = true);
    try {
      final uid = _authRepository.currentUserId;
      await _locationService.sendEmergencyAlert(uid);
      _showSuccessSnackBar('Emergency alert sent successfully ✓');
    } catch (e) {
      _showErrorSnackBar(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSendingEmergency = false);
    }
  }

  Future<void> _cancelRecording() async {
    if (!isRecording) return;
    await _voiceService.cancelRecording();
    if (mounted) setState(() => isRecording = false);
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
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

    final List<Map<String, dynamic>> myCareCards = [
      {
        'category': l10n.myCare,
        'icon': Icons.folder_open,
        'title': l10n.healthRecords,
        'subtitle': l10n.viewMedicalHistory,
        'color': const Color(0xFF06B6D4),
      },
      {
        'category': l10n.myCare,
        'icon': Icons.medication,
        'title': l10n.medicines,
        'subtitle': l10n.manageMedications,
        'color': const Color(0xFF8B5CF6),
      },
    ];

    final List<Map<String, dynamic>> myNetworkCards = [
      {
        'category': l10n.myNetwork,
        'icon': Icons.people,
        'title': l10n.familyAndDoctor,
        'subtitle': l10n.emergencyContacts,
        'color': const Color(0xFF3B82F6),
      },
      {
        'category': l10n.myNetwork,
        'icon': Icons.local_pharmacy,
        'title': l10n.labsAndPharmacy,
        'subtitle': l10n.findLabsAndMedicine,
        'color': const Color(0xFFF59E0B),
      },
    ];

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: ResponsiveSize.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerEffect(
                            width: ResponsiveSize.w(60),
                            height: ResponsiveSize.h(3),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(50),
                            height: ResponsiveSize.h(2),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        ShimmerEffect(
                          width: ResponsiveSize.w(8),
                          height: ResponsiveSize.w(8),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(4),
                          ),
                        ),
                        SizedBox(width: ResponsiveSize.w(2)),
                        ShimmerEffect(
                          width: ResponsiveSize.w(8),
                          height: ResponsiveSize.w(8),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(4),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(3)),
                ShimmerEffect(
                  width: double.infinity,
                  height: ResponsiveSize.h(25),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                ),
                SizedBox(height: ResponsiveSize.h(4)),
                Row(
                  children: [
                    ShimmerEffect(
                      width: ResponsiveSize.w(1),
                      height: ResponsiveSize.h(2.5),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                    SizedBox(width: ResponsiveSize.w(2)),
                    ShimmerEffect(
                      width: ResponsiveSize.w(20),
                      height: ResponsiveSize.h(2.5),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(.5)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: ResponsiveSize.w(4),
                    mainAxisSpacing: ResponsiveSize.h(2),
                    childAspectRatio: 0.95,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerEffect(
                            width: ResponsiveSize.w(12),
                            height: ResponsiveSize.w(12),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(3),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(25),
                            height: ResponsiveSize.h(2),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(30),
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
                SizedBox(height: ResponsiveSize.h(2)),
                Row(
                  children: [
                    ShimmerEffect(
                      width: ResponsiveSize.w(1),
                      height: ResponsiveSize.h(2.5),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                    SizedBox(width: ResponsiveSize.w(1)),
                    ShimmerEffect(
                      width: ResponsiveSize.w(25),
                      height: ResponsiveSize.h(2.5),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveSize.h(.5)),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: ResponsiveSize.w(4),
                    mainAxisSpacing: ResponsiveSize.h(2),
                    childAspectRatio: 0.95,
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(4),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShimmerEffect(
                            width: ResponsiveSize.w(12),
                            height: ResponsiveSize.w(12),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(3),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(2)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(25),
                            height: ResponsiveSize.h(2),
                            borderRadius: BorderRadius.circular(
                              ResponsiveSize.w(1),
                            ),
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(30),
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
                SizedBox(height: ResponsiveSize.h(3)),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: isRecording ? _buildRecordingBar() : null,

      // ── Voice Mic FAB ─────────────────────────────────────────────────────
      floatingActionButton: GestureDetector(
        onTap: () {
          if (isRecording) {
            _cancelRecording();
          } else if (!isProcessing) {
            _startRecording();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: ResponsiveSize.w(15),
          height: ResponsiveSize.w(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isRecording
                ? Colors.red
                : isProcessing
                ? Colors.orange
                : AppColors.primary,
            boxShadow: [
              BoxShadow(
                color:
                    (isRecording
                            ? Colors.red
                            : isProcessing
                            ? Colors.orange
                            : AppColors.primary)
                        .withOpacity(0.45),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: isProcessing
              ? const Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : Icon(
                  isRecording ? Icons.close_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: ResponsiveSize.icon(3.2),
                ),
        ),
      ),

      // ─────────────────────────────────────────────────────────────────────
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveSize.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                          ).createShader(bounds),
                          child: Text(
                            l10n.goodEvening(userName),
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveSize.h(0.2)),
                        Text(
                          l10n.healthDashboardSubtitle,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: const Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Language switcher
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<String>(
                            color: AppColors.white,
                            padding: EdgeInsets.zero,
                            offset: const Offset(0, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF64748B).withOpacity(0.1),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: ResponsiveSize.w(5.5),
                                backgroundColor: const Color(0xFFF1F5F9),
                                child: Icon(
                                  Icons.language,
                                  color: const Color(0xFF10B981),
                                  size: ResponsiveSize.icon(2.5),
                                ),
                              ),
                            ),
                            onSelected: (String value) {
                              if (value == 'en') {
                                MyApp.setLocale(context, const Locale('en'));
                              } else if (value == 'ur') {
                                MyApp.setLocale(context, const Locale('ur'));
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'en',
                                    child: Text('English'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'ur',
                                    child: Text('اردو'),
                                  ),
                                ],
                          ),
                          SizedBox(height: ResponsiveSize.h(0.4)),
                          Text(
                            'Language',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textGray,
                              fontSize: ResponsiveSize.font(10),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: ResponsiveSize.w(3)),
                      // Profile button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: ResponsiveSize.w(5.5),
                                backgroundColor: AppColors.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                  size: ResponsiveSize.icon(2.5),
                                ),
                              ),
                            ),
                            SizedBox(height: ResponsiveSize.h(0.4)),
                            Text(
                              'Profile',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.textGray,
                                fontSize: ResponsiveSize.font(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: ResponsiveSize.h(3)),

              // Emergency Alert Card
              GestureDetector(
                onLongPress: _isSendingEmergency ? null : _triggerEmergency,
                child: Container(
                  width: double.infinity,
                  padding: ResponsiveSize.symmetric(h: 3, v: 3),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFF991B1B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(4)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.5),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: ResponsiveSize.all(2.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.notification_important_rounded,
                          color: AppColors.white,
                          size: ResponsiveSize.icon(5),
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(1.5)),
                      Text(
                        l10n.emergencyAlert,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(0.8)),
                      Text(
                        l10n.emergencyAlertSubtitle,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.white.withOpacity(0.95),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(1.5)),
                      Container(
                        padding: ResponsiveSize.symmetric(h: 8, v: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(8),
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Text(
                          l10n.holdToActivate,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: ResponsiveSize.h(4)),

              // My Care Section
              Row(
                children: [
                  Container(
                    width: ResponsiveSize.w(1),
                    height: ResponsiveSize.h(2.5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF06B6D4), Color(0xFF8B5CF6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(2)),
                  Text(
                    l10n.myCare,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(.5)),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: ResponsiveSize.w(4),
                  mainAxisSpacing: ResponsiveSize.h(2),
                  childAspectRatio: 0.95,
                ),
                itemCount: myCareCards.length,
                itemBuilder: (context, index) {
                  final card = myCareCards[index];
                  return ActionCard(
                    category: card['category'],
                    icon: card['icon'],
                    title: card['title'],
                    subtitle: card['subtitle'],
                    color: card['color'],
                    onTap: () {
                      if (card['title'] == l10n.medicines) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyMedicineScreen(),
                          ),
                        );
                      } else if (card['title'] == l10n.healthRecords) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HealthRecordsScreen(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),

              SizedBox(height: ResponsiveSize.h(2)),

              // My Network Section
              Row(
                children: [
                  Container(
                    width: ResponsiveSize.w(1),
                    height: ResponsiveSize.h(2.5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFFF59E0B)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(1)),
                  Text(
                    l10n.myNetwork,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(.5)),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: ResponsiveSize.w(4),
                  mainAxisSpacing: ResponsiveSize.h(2),
                  childAspectRatio: 0.95,
                ),
                itemCount: myNetworkCards.length,
                itemBuilder: (context, index) {
                  final card = myNetworkCards[index];
                  return ActionCard(
                    category: card['category'],
                    icon: card['icon'],
                    title: card['title'],
                    subtitle: card['subtitle'],
                    color: card['color'],
                    onTap: () {
                      if (card['title'] == l10n.familyAndDoctor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyContactsScreen(),
                          ),
                        );
                      } else if (card['title'] == l10n.labsAndPharmacy) {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(ResponsiveSize.w(5)),
                            ),
                          ),
                          builder: (context) => Padding(
                            padding: ResponsiveSize.all(5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.labsAndPharmacy,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(height: ResponsiveSize.h(2)),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF7C3AED).withOpacity(0.1),
                                    child: const Icon(Icons.biotech_outlined, color: Color(0xFF7C3AED)),
                                  ),
                                  title: Text('My Labs', style: AppTextStyles.titleSmall),
                                  subtitle: Text('View & manage your labs', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
                                  trailing: Icon(Icons.chevron_right, color: AppColors.textGray),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyLabsScreen()),
                                    );
                                  },
                                ),
                                SizedBox(height: ResponsiveSize.h(1)),
                                ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(0xFF0EA5E9).withOpacity(0.1),
                                    child: const Icon(Icons.local_pharmacy_outlined, color: Color(0xFF0EA5E9)),
                                  ),
                                  title: Text('My Pharmacies', style: AppTextStyles.titleSmall),
                                  subtitle: Text('View & manage your pharmacies', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray)),
                                  trailing: Icon(Icons.chevron_right, color: AppColors.textGray),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const MyPharmacyScreen()),
                                    );
                                  },
                                ),
                                SizedBox(height: ResponsiveSize.h(2)),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),

              SizedBox(height: ResponsiveSize.h(3)),
            ],
          ),
        ),
      ),
    );
  }
}
