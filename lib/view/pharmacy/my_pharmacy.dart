import 'package:flutter/material.dart';
import '../../data/model/pharmacy/pharmacy_model.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/pharmacy/pharmacy_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/shimmer_effect.dart';
import '../../utils/constants/text_styles.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/exceptions/exceptions.dart';
import 'widgets/add_pharmacy.dart';
import 'widgets/pharmacy_card.dart';

class MyPharmacyScreen extends StatefulWidget {
  const MyPharmacyScreen({super.key});

  @override
  State<MyPharmacyScreen> createState() => _MyPharmacyScreenState();
}

class _MyPharmacyScreenState extends State<MyPharmacyScreen> {
  final AuthRepository authRepository = AuthRepository();
  final PharmacyRepository pharmacyRepository = PharmacyRepository();

  void _navigateToAddPharmacy() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddPharmacyScreen()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Future<void> _handleDeletePharmacy(String pharmacyId) async {
    try {
      await pharmacyRepository.deletePharmacy(
        authRepository.currentUserId,
        pharmacyId,
      );
      showSuccessSnackBar('Pharmacy deleted successfully');
      setState(() {});
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to delete pharmacy');
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
        title: 'My Pharmacies',
        actions: [
          IconButton(
            onPressed: _navigateToAddPharmacy,
            icon: Icon(
              Icons.add,
              color: AppColors.primary,
              size: ResponsiveSize.icon(3),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<PharmacyModel>>(
        stream: pharmacyRepository.getPharmaciesStream(
          authRepository.currentUserId,
        ),
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
                    'Error loading pharmacies',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          final pharmacies = snapshot.data ?? [];

          if (pharmacies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_pharmacy_outlined,
                    size: ResponsiveSize.icon(10),
                    color: AppColors.textGray,
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  Text(
                    'No pharmacies added yet',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(16),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),
                  Text(
                    'Tap + to add your first pharmacy',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ElevatedButton.icon(
                    onPressed: _navigateToAddPharmacy,
                    icon: Icon(Icons.add, size: ResponsiveSize.icon(2.5)),
                    label: const Text('Add Pharmacy'),
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
                  'Pharmacies (${pharmacies.length})',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(2)),
                ...pharmacies.map(
                  (pharmacy) => PharmacyCard(
                    name: pharmacy.name,
                    phoneNumber: pharmacy.phoneNumber,
                    address: pharmacy.address,
                    city: pharmacy.city,
                    onDelete: () => _handleDeletePharmacy(pharmacy.id),
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
