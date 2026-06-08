import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/contacts/contact_model.dart';
import '../../../data/repository/authentication/authentication_repository.dart';
import '../../../data/repository/contact/contact_repository.dart';
import '../../../shared/widgets/custom_appbar.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../../utils/device/responsive_size.dart';
import '../../../utils/exceptions/exceptions.dart';
import '../../../utils/formatters/formatters.dart';
import '../../../utils/validators/validators.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => AddContactScreenState();
}

class AddContactScreenState extends State<AddContactScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final ContactRepository contactRepository = ContactRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedType = 'Family';
  bool isLoading = false;

  Future<void> handleSaveContact() async {
    if (!formKey.currentState!.validate()) {
      showErrorSnackBar('Please fill all required fields');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final contactId = const Uuid().v4();
      final userId = authRepository.currentUserId;

      final contact = ContactModel(
        id: contactId,
        userId: userId,
        name: nameController.text.trim(),
        relationship: relationshipController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        type: selectedType,
        email: emailController.text.trim().isNotEmpty
            ? emailController.text.trim()
            : null,
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        createdAt: DateTime.now(),
      );

      await contactRepository.createContact(contact);

      if (mounted) {
        showSuccessSnackBar('Contact saved successfully');
        Navigator.pop(context, true);
      }
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to save contact. Please try again.');
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
      appBar: CustomAppBar(title: l10n.addContact),
      body: SingleChildScrollView(
        padding: ResponsiveSize.all(4),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.contactTypeLabel,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.lightGreen,
                ),
              ),
              SizedBox(height: ResponsiveSize.h(1.5)),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'Family';
                        });
                      },
                      child: Container(
                        padding: ResponsiveSize.symmetric(v: 2),
                        decoration: BoxDecoration(
                          color: selectedType == 'Family'
                              ? Colors.blue.withOpacity(0.1)
                              : AppColors.white,
                          border: Border.all(
                            color: selectedType == 'Family'
                                ? Colors.blue
                                : AppColors.border,
                            width: selectedType == 'Family' ? 2 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.family_restroom,
                              color: selectedType == 'Family'
                                  ? Colors.blue
                                  : AppColors.textGray,
                              size: ResponsiveSize.icon(3.5),
                            ),
                            SizedBox(height: ResponsiveSize.h(0.5)),
                            Text(
                              l10n.family,
                              style: TextStyle(
                                fontSize: ResponsiveSize.font(12),
                                color: selectedType == 'Family'
                                    ? Colors.blue
                                    : AppColors.textDark,
                                fontWeight: selectedType == 'Family'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(3)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'Doctor';
                        });
                      },
                      child: Container(
                        padding: ResponsiveSize.symmetric(v: 2),
                        decoration: BoxDecoration(
                          color: selectedType == 'Doctor'
                              ? AppColors.lightGreen.withOpacity(0.1)
                              : AppColors.white,
                          border: Border.all(
                            color: selectedType == 'Doctor'
                                ? AppColors.lightGreen
                                : AppColors.border,
                            width: selectedType == 'Doctor' ? 2 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.medical_services,
                              color: selectedType == 'Doctor'
                                  ? AppColors.lightGreen
                                  : AppColors.textGray,
                              size: ResponsiveSize.icon(3.5),
                            ),
                            SizedBox(height: ResponsiveSize.h(0.5)),
                            Text(
                              l10n.doctor,
                              style: TextStyle(
                                fontSize: ResponsiveSize.font(12),
                                color: selectedType == 'Doctor'
                                    ? AppColors.lightGreen
                                    : AppColors.textDark,
                                fontWeight: selectedType == 'Doctor'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveSize.w(3)),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedType = 'Friend';
                        });
                      },
                      child: Container(
                        padding: ResponsiveSize.symmetric(v: 2),
                        decoration: BoxDecoration(
                          color: selectedType == 'Friend'
                              ? Colors.orange.withOpacity(0.1)
                              : AppColors.white,
                          border: Border.all(
                            color: selectedType == 'Friend'
                                ? Colors.orange
                                : AppColors.border,
                            width: selectedType == 'Friend' ? 2 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.people,
                              color: selectedType == 'Friend'
                                  ? Colors.orange
                                  : AppColors.textGray,
                              size: ResponsiveSize.icon(3.5),
                            ),
                            SizedBox(height: ResponsiveSize.h(0.5)),
                            Text(
                              l10n.friend,
                              style: TextStyle(
                                fontSize: ResponsiveSize.font(12),
                                color: selectedType == 'Friend'
                                    ? Colors.orange
                                    : AppColors.textDark,
                                fontWeight: selectedType == 'Friend'
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveSize.h(3)),

              CustomTextField(
                hintText: l10n.enterFullName,
                labelText: l10n.contactNameLabel,
                controller: nameController,
                inputFormatters: AppFormatters.nameFormatter(),
                validator: Validators.validateFullName,
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: selectedType == 'Doctor'
                    ? l10n.doctorRelationshipHint
                    : selectedType == 'Family'
                    ? l10n.familyRelationshipHint
                    : l10n.friendRelationshipHint,
                labelText: l10n.relationshipLabel,
                controller: relationshipController,
                validator: (value) =>
                    Validators.validateRequired(value, 'Relationship'),
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.enterPhoneNumber,
                labelText: l10n.phoneNumberLabel,
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: AppFormatters.phoneNumberFormatter(),
                validator: Validators.validatePhoneNumber,
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.enterEmailAddress,
                labelText: l10n.emailOptionalLabel,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    return Validators.validateEmail(value);
                  }
                  return null;
                },
              ),
              SizedBox(height: ResponsiveSize.h(2)),

              CustomTextField(
                hintText: l10n.enterAddress,
                labelText: l10n.addressOptionalLabel,
                controller: addressController,
                maxLines: 3,
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
                  text: isLoading ? l10n.savingContact : l10n.saveContact,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                  onPressed: isLoading ? null : handleSaveContact,
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
    relationshipController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
