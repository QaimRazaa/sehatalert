import 'package:flutter/material.dart';
import '../../data/model/lab/lab_model.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/lab/lab_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/shimmer_effect.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/exceptions/exceptions.dart';
import 'widgets/add_lab.dart';
import 'widgets/lab_card.dart';

class MyLabsScreen extends StatefulWidget {
  const MyLabsScreen({super.key});

  @override
  State<MyLabsScreen> createState() => _MyLabsScreenState();
}

class _MyLabsScreenState extends State<MyLabsScreen> {
  final AuthRepository authRepository = AuthRepository();
  final LabRepository labRepository = LabRepository();

  void _navigateToAddLab() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddLabScreen()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _handleDeleteLab(String labId) async {
    try {
      await labRepository.deleteLab(authRepository.currentUserId, labId);
      showSuccessSnackBar('Lab deleted successfully');
      setState(() {});
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to delete lab');
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

  Widget _buildShimmerList() {
    return SingleChildScrollView(
      padding: ResponsiveSize.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(
            width: ResponsiveSize.w(40),
            height: ResponsiveSize.h(2.5),
            borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
          ),
          SizedBox(height: ResponsiveSize.h(2)),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                margin: ResponsiveSize.only(bottom: 2),
                padding: ResponsiveSize.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
                ),
                child: Row(
                  children: [
                    ShimmerEffect(
                      width: ResponsiveSize.w(12),
                      height: ResponsiveSize.w(12),
                      borderRadius: BorderRadius.circular(
                        ResponsiveSize.w(6),
                      ),
                    ),
                    SizedBox(width: ResponsiveSize.w(4)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerEffect(
                            width: ResponsiveSize.w(40),
                            height: ResponsiveSize.h(2),
                            borderRadius:
                                BorderRadius.circular(ResponsiveSize.w(1)),
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(30),
                            height: ResponsiveSize.h(1.5),
                            borderRadius:
                                BorderRadius.circular(ResponsiveSize.w(1)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      appBar: CustomAppBar(
        title: 'My Labs',
        actions: [
          IconButton(
            onPressed: _navigateToAddLab,
            icon: Icon(
              Icons.add,
              color: AppColors.primary,
              size: ResponsiveSize.icon(3),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<LabModel>>(
        stream: labRepository.getLabsStream(authRepository.currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerList();
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
                    'Error loading labs',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          final labs = snapshot.data ?? [];

          if (labs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.biotech_outlined,
                    size: ResponsiveSize.icon(10),
                    color: AppColors.textGray,
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  Text(
                    'No labs added yet',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(16),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),
                  Text(
                    'Tap + to add your first lab',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ElevatedButton.icon(
                    onPressed: _navigateToAddLab,
                    icon: Icon(Icons.add, size: ResponsiveSize.icon(2.5)),
                    label: const Text('Add Lab'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: ResponsiveSize.symmetric(h: 6, v: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: ResponsiveSize.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Labs (${labs.length})',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(2)),
                ...labs.map(
                  (lab) => LabCard(
                    name: lab.name,
                    phoneNumber: lab.phoneNumber,
                    address: lab.address,
                    city: lab.city,
                    openingHours: lab.openingHours,
                    onDelete: () => _handleDeleteLab(lab.id),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
