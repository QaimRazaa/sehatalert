import 'package:flutter/material.dart';
import 'package:sehatalert/view/contacts/widgets/add_contact.dart';
import 'package:sehatalert/view/contacts/widgets/contact_card.dart';
import 'package:sehatalert/view/contacts/widgets/emergency_contact.dart';
import '../../data/model/contacts/contact_model.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../data/repository/contact/contact_repository.dart';
import '../../shared/widgets/custom_appbar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/shimmer_effect.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/exceptions/exceptions.dart';

class MyContactsScreen extends StatefulWidget {
  const MyContactsScreen({super.key});

  @override
  State<MyContactsScreen> createState() => MyContactsScreenState();
}

class MyContactsScreenState extends State<MyContactsScreen> {
  final AuthRepository authRepository = AuthRepository();
  final ContactRepository contactRepository = ContactRepository();

  String? emergencyContactName;
  String? emergencyContactRelationship;
  String? emergencyContactPhone;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEmergencyContact();
  }

  Future<void> loadEmergencyContact() async {
    try {
      final userData = await authRepository.getCurrentUserData();

      if (userData != null && userData.patientInfo != null) {
        setState(() {
          emergencyContactName = userData.patientInfo!.emergencyContact.name;
          emergencyContactRelationship =
              userData.patientInfo!.emergencyContact.relationship;
          emergencyContactPhone =
              userData.patientInfo!.emergencyContact.phoneNumber;
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
      showErrorSnackBar('Error loading emergency contact: ${e.toString()}');
    }
  }

  void navigateToAddContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddContactScreen()),
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

  Future<void> handleDeleteContact(String contactId) async {
    try {
      await contactRepository.deleteContact(
        authRepository.currentUserId,
        contactId,
      );
      showSuccessSnackBar('Contact deleted successfully');
      setState(() {});
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Failed to delete contact');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.lightWhite,
        appBar: CustomAppBar(
          title: l10n.myContacts,
          actions: [
            IconButton(
              onPressed: navigateToAddContact,
              icon: Icon(
                Icons.add,
                color: AppColors.lightGreen,
                size: ResponsiveSize.icon(3),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
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
              Container(
                padding: ResponsiveSize.all(4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
                ),
                child: Row(
                  children: [
                    ShimmerEffect(
                      width: ResponsiveSize.w(15),
                      height: ResponsiveSize.w(15),
                      borderRadius: BorderRadius.circular(
                        ResponsiveSize.w(7.5),
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
                          SizedBox(height: ResponsiveSize.h(1)),
                          ShimmerEffect(
                            width: ResponsiveSize.w(35),
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
              ),
              SizedBox(height: ResponsiveSize.h(3)),
              ShimmerEffect(
                width: ResponsiveSize.w(30),
                height: ResponsiveSize.h(2.5),
                borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
              ),
              SizedBox(height: ResponsiveSize.h(2)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
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
                          width: ResponsiveSize.w(15),
                          height: ResponsiveSize.w(15),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(7.5),
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
                              SizedBox(height: ResponsiveSize.h(1)),
                              ShimmerEffect(
                                width: ResponsiveSize.w(35),
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
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      appBar: CustomAppBar(
        title: l10n.myContacts,
        actions: [
          IconButton(
            onPressed: navigateToAddContact,
            icon: Icon(
              Icons.add,
              color: AppColors.lightGreen,
              size: ResponsiveSize.icon(3),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ContactModel>>(
        stream: contactRepository.getContactsStream(
          authRepository.currentUserId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
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
                  Container(
                    padding: ResponsiveSize.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(ResponsiveSize.w(3)),
                    ),
                    child: Row(
                      children: [
                        ShimmerEffect(
                          width: ResponsiveSize.w(15),
                          height: ResponsiveSize.w(15),
                          borderRadius: BorderRadius.circular(
                            ResponsiveSize.w(7.5),
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
                              SizedBox(height: ResponsiveSize.h(1)),
                              ShimmerEffect(
                                width: ResponsiveSize.w(35),
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
                  ),
                  SizedBox(height: ResponsiveSize.h(3)),
                  ShimmerEffect(
                    width: ResponsiveSize.w(30),
                    height: ResponsiveSize.h(2.5),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(1)),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
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
                        child: Row(
                          children: [
                            ShimmerEffect(
                              width: ResponsiveSize.w(15),
                              height: ResponsiveSize.w(15),
                              borderRadius: BorderRadius.circular(
                                ResponsiveSize.w(7.5),
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
                                  SizedBox(height: ResponsiveSize.h(1)),
                                  ShimmerEffect(
                                    width: ResponsiveSize.w(35),
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
                      );
                    },
                  ),
                ],
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
                    'Error loading contacts',
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(14),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }

          final contacts = snapshot.data ?? [];
          final familyContacts = contacts
              .where((c) => c.type == 'Family')
              .toList();
          final doctorContacts = contacts
              .where((c) => c.type == 'Doctor')
              .toList();
          final friendContacts = contacts
              .where((c) => c.type == 'Friend')
              .toList();

          final hasEmergencyContact =
              emergencyContactName != null && emergencyContactName!.isNotEmpty;
          final hasAnyContact = contacts.isNotEmpty || hasEmergencyContact;

          if (!hasAnyContact) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contacts_outlined,
                    size: ResponsiveSize.icon(10),
                    color: AppColors.textGray,
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  Text(
                    l10n.noContactsAdded,
                    style: TextStyle(
                      fontSize: ResponsiveSize.font(16),
                      color: AppColors.textGray,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(1)),
                  ElevatedButton.icon(
                    onPressed: navigateToAddContact,
                    icon: Icon(Icons.add, size: ResponsiveSize.icon(2.5)),
                    label: Text(l10n.addContact),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGreen,
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
                if (hasEmergencyContact) ...[
                  Text(
                    l10n.emergencyContact,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  EmergencyContactCard(
                    name: emergencyContactName!,
                    relationship: emergencyContactRelationship!,
                    phoneNumber: emergencyContactPhone!,
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                ],
                if (familyContacts.isNotEmpty) ...[
                  Text(
                    l10n.family,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ...familyContacts.map((contact) {
                    return ContactCard(
                      name: contact.name,
                      relationship: contact.relationship,
                      phoneNumber: contact.phoneNumber,
                      type: contact.type,
                      onEdit: navigateToAddContact,
                      onDelete: () => handleDeleteContact(contact.id),
                    );
                  }),
                ],
                if (doctorContacts.isNotEmpty) ...[
                  Text(
                    l10n.doctor,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ...doctorContacts.map((contact) {
                    return ContactCard(
                      name: contact.name,
                      relationship: contact.relationship,
                      phoneNumber: contact.phoneNumber,
                      type: contact.type,
                      onEdit: navigateToAddContact,
                      onDelete: () => handleDeleteContact(contact.id),
                    );
                  }),
                ],
                if (friendContacts.isNotEmpty) ...[
                  Text(
                    l10n.friends,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: ResponsiveSize.h(2)),
                  ...friendContacts.map((contact) {
                    return ContactCard(
                      name: contact.name,
                      relationship: contact.relationship,
                      phoneNumber: contact.phoneNumber,
                      type: contact.type,
                      onEdit: navigateToAddContact,
                      onDelete: () => handleDeleteContact(contact.id),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
