import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/lab/lab_model.dart';
import '../../../data/repository/authentication/authentication_repository.dart';
import '../../../data/repository/lab/lab_repository.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import '../../../utils/device/responsive_size.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../../utils/formatters/formatters.dart';
import '../../../utils/validators/validators.dart';

class AddLabScreen extends StatefulWidget {
  const AddLabScreen({super.key});

  @override
  State<AddLabScreen> createState() => _AddLabScreenState();
}

class _AddLabScreenState extends State<AddLabScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final LabRepository labRepository = LabRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController openingHoursController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isLoading = false;

  Future<void> handleSaveLab() async {
    if (!formKey.currentState!.validate()) {
      showErrorSnackBar('Please fill all required fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final labId = const Uuid().v4();
      final userId = authRepository.currentUserId;

      final lab = LabModel(
        id: labId,
        userId: userId,
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        city: cityController.text.trim().isNotEmpty
            ? cityController.text.trim()
            : null,
        openingHours: openingHoursController.text.trim().isNotEmpty
            ? openingHoursController.text.trim()
            : null,
        notes: notesController.text.trim().isNotEmpty
            ? notesController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      await labRepository.createLab(lab);

      if (mounted) {
        showSuccessSnackBar('Lab saved successfully');
        Navigator.pop(context, true);
      }
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to save lab. Please try again.');
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
    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      appBar: const CustomAppBar(title: 'Add Lab'),
      body: SingleChildScrollView(
        padding: ResponsiveSize.all(4),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lab Information',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'e.g. Chughtai Lab',
                labelText: 'Lab Name *',
                controller: nameController,
                prefixIcon: Icon(
                  Icons.biotech_outlined,
                  color: AppColors.primary,
                ),
                prefixPadding: ResponsiveSize.only(left: 2),
                inputFormatters: AppFormatters.nameFormatter(),
                validator: (value) =>
                    Validators.validateRequired(value, 'Lab name'),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'e.g. 03001234567',
                labelText: 'Phone Number *',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: AppColors.primary,
                ),
                prefixPadding: ResponsiveSize.only(left: 2),
                inputFormatters: AppFormatters.phoneNumberFormatter(),
                validator: Validators.validatePhoneNumber,
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'e.g. Lahore',
                labelText: 'City (Optional)',
                controller: cityController,
                prefixIcon: Icon(
                  Icons.location_city_outlined,
                  color: AppColors.primary,
                ),
                prefixPadding: ResponsiveSize.only(left: 2),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'e.g. 12 Main Boulevard, Gulberg',
                labelText: 'Address (Optional)',
                controller: addressController,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                ),
                prefixPadding: ResponsiveSize.only(left: 2),
                maxLines: 2,
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'e.g. 8 AM – 10 PM',
                labelText: 'Opening Hours (Optional)',
                controller: openingHoursController,
                prefixIcon: Icon(
                  Icons.access_time_outlined,
                  color: AppColors.primary,
                ),
                prefixPadding: ResponsiveSize.only(left: 2),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              CustomTextField(
                hintText: 'Any additional notes',
                labelText: 'Notes (Optional)',
                controller: notesController,
                maxLines: 3,
              ),
              SizedBox(height: ResponsiveSize.h(3)),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: CustomElevatedButton(
                  text: isLoading ? 'Saving...' : 'Save Lab',
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                  onPressed: isLoading ? null : handleSaveLab,
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
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    openingHoursController.dispose();
    notesController.dispose();
    super.dispose();
  }
}
