import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue your health journey'**
  String get signInSubtitle;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailLabel;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging In...'**
  String get loggingIn;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @healthProtected.
  ///
  /// In en, this message translates to:
  /// **'Your health is always protected'**
  String get healthProtected;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign up to get started with your health journey'**
  String get signUpSubtitle;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameLabel;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneNumberLabel;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get confirmPasswordLabel;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions and Privacy Policy'**
  String get termsAndConditions;

  /// No description provided for @registering.
  ///
  /// In en, this message translates to:
  /// **'Registering...'**
  String get registering;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number to reset password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Sending OTP...'**
  String get sendingOtp;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @rememberYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberYourPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @enterNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get enterNewPasswordHint;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password *'**
  String get newPasswordLabel;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @resetting.
  ///
  /// In en, this message translates to:
  /// **'Resetting...'**
  String get resetting;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @verifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get verifying;

  /// No description provided for @healthDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your health & safety dashboard'**
  String get healthDashboardSubtitle;

  /// No description provided for @emergencyAlert.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY ALERT'**
  String get emergencyAlert;

  /// No description provided for @emergencyAlertSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One tap sends alert to family & doctor'**
  String get emergencyAlertSubtitle;

  /// No description provided for @holdToActivate.
  ///
  /// In en, this message translates to:
  /// **'HOLD TO ACTIVATE'**
  String get holdToActivate;

  /// No description provided for @myCare.
  ///
  /// In en, this message translates to:
  /// **'My Care'**
  String get myCare;

  /// No description provided for @myNetwork.
  ///
  /// In en, this message translates to:
  /// **'My Network'**
  String get myNetwork;

  /// No description provided for @healthRecords.
  ///
  /// In en, this message translates to:
  /// **'Health Records'**
  String get healthRecords;

  /// No description provided for @viewMedicalHistory.
  ///
  /// In en, this message translates to:
  /// **'View medical history'**
  String get viewMedicalHistory;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @manageMedications.
  ///
  /// In en, this message translates to:
  /// **'Manage medications'**
  String get manageMedications;

  /// No description provided for @familyAndDoctor.
  ///
  /// In en, this message translates to:
  /// **'Family & Doctor'**
  String get familyAndDoctor;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency contacts'**
  String get emergencyContacts;

  /// No description provided for @labsAndPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Labs & Pharmacy'**
  String get labsAndPharmacy;

  /// No description provided for @findLabsAndMedicine.
  ///
  /// In en, this message translates to:
  /// **'Find labs & medicine'**
  String get findLabsAndMedicine;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @healthMetrics.
  ///
  /// In en, this message translates to:
  /// **'Health Metrics'**
  String get healthMetrics;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @medicalConditions.
  ///
  /// In en, this message translates to:
  /// **'Medical Conditions'**
  String get medicalConditions;

  /// No description provided for @knownAllergies.
  ///
  /// In en, this message translates to:
  /// **'Known Allergies'**
  String get knownAllergies;

  /// No description provided for @currentMedicines.
  ///
  /// In en, this message translates to:
  /// **'Current Medicines'**
  String get currentMedicines;

  /// No description provided for @noMedicinesAdded.
  ///
  /// In en, this message translates to:
  /// **'No medicines added'**
  String get noMedicinesAdded;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'Records'**
  String get records;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @patientInformation.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInformation;

  /// No description provided for @basicDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic Details'**
  String get basicDetails;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth *'**
  String get dateOfBirthLabel;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select gender'**
  String get selectGender;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender *'**
  String get genderLabel;

  /// No description provided for @healthAndSafety.
  ///
  /// In en, this message translates to:
  /// **'Health & Safety'**
  String get healthAndSafety;

  /// No description provided for @bloodGroupHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., A+, B-, O+'**
  String get bloodGroupHint;

  /// No description provided for @bloodGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Group (Optional)'**
  String get bloodGroupLabel;

  /// No description provided for @listAllergies.
  ///
  /// In en, this message translates to:
  /// **'List any known allergies'**
  String get listAllergies;

  /// No description provided for @knownAllergiesLabel.
  ///
  /// In en, this message translates to:
  /// **'Known Allergies *'**
  String get knownAllergiesLabel;

  /// No description provided for @emergencyInformation.
  ///
  /// In en, this message translates to:
  /// **'Emergency Information'**
  String get emergencyInformation;

  /// No description provided for @emergencyContact1.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact 1 *'**
  String get emergencyContact1;

  /// No description provided for @enterContactName.
  ///
  /// In en, this message translates to:
  /// **'Enter contact name'**
  String get enterContactName;

  /// No description provided for @contactNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Name *'**
  String get contactNameLabel;

  /// No description provided for @relationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Father, Mother, Spouse'**
  String get relationshipHint;

  /// No description provided for @relationshipLabel.
  ///
  /// In en, this message translates to:
  /// **'Relationship *'**
  String get relationshipLabel;

  /// No description provided for @optionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Optional Details'**
  String get optionalDetails;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 65'**
  String get heightHint;

  /// No description provided for @heightLabel.
  ///
  /// In en, this message translates to:
  /// **'Height (inches)'**
  String get heightLabel;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 70'**
  String get weightHint;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @enterCityName.
  ///
  /// In en, this message translates to:
  /// **'Enter city name'**
  String get enterCityName;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @mobileNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number *'**
  String get mobileNumberLabel;

  /// No description provided for @enterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get enterMobileNumber;

  /// No description provided for @diseaseSelection.
  ///
  /// In en, this message translates to:
  /// **'Disease Selection'**
  String get diseaseSelection;

  /// No description provided for @selectChronicDiseases.
  ///
  /// In en, this message translates to:
  /// **'Select Chronic Diseases'**
  String get selectChronicDiseases;

  /// No description provided for @selectConditions.
  ///
  /// In en, this message translates to:
  /// **'Select one or more conditions that apply'**
  String get selectConditions;

  /// No description provided for @diabetes.
  ///
  /// In en, this message translates to:
  /// **'Diabetes'**
  String get diabetes;

  /// No description provided for @heartDisease.
  ///
  /// In en, this message translates to:
  /// **'Heart Disease'**
  String get heartDisease;

  /// No description provided for @hypertension.
  ///
  /// In en, this message translates to:
  /// **'Hypertension (High BP)'**
  String get hypertension;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @myContacts.
  ///
  /// In en, this message translates to:
  /// **'My Contacts'**
  String get myContacts;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @noContactsAdded.
  ///
  /// In en, this message translates to:
  /// **'No contacts added yet'**
  String get noContactsAdded;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add Contact'**
  String get addContact;

  /// No description provided for @errorLoadingContacts.
  ///
  /// In en, this message translates to:
  /// **'Error loading contacts'**
  String get errorLoadingContacts;

  /// No description provided for @contactTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Type *'**
  String get contactTypeLabel;

  /// No description provided for @doctorRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cardiologist, General Physician'**
  String get doctorRelationshipHint;

  /// No description provided for @familyRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Father, Mother, Brother'**
  String get familyRelationshipHint;

  /// No description provided for @friendRelationshipHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Close Friend, Colleague'**
  String get friendRelationshipHint;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptionalLabel;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @addressOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (Optional)'**
  String get addressOptionalLabel;

  /// No description provided for @savingContact.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingContact;

  /// No description provided for @saveContact.
  ///
  /// In en, this message translates to:
  /// **'Save Contact'**
  String get saveContact;

  /// No description provided for @friend.
  ///
  /// In en, this message translates to:
  /// **'Friend'**
  String get friend;

  /// No description provided for @myMedicine.
  ///
  /// In en, this message translates to:
  /// **'My Medicine'**
  String get myMedicine;

  /// No description provided for @noMedicinesAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No medicines added yet'**
  String get noMedicinesAddedYet;

  /// No description provided for @tapToAddMedicine.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first medicine'**
  String get tapToAddMedicine;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @medicineNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Paracetamol 500mg'**
  String get medicineNameHint;

  /// No description provided for @medicineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name *'**
  String get medicineNameLabel;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @medicineTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicine Type *'**
  String get medicineTypeLabel;

  /// No description provided for @dosageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 1 tablet, 5ml'**
  String get dosageHint;

  /// No description provided for @dosageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage *'**
  String get dosageLabel;

  /// No description provided for @selectFrequency.
  ///
  /// In en, this message translates to:
  /// **'Select frequency'**
  String get selectFrequency;

  /// No description provided for @frequencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Frequency *'**
  String get frequencyLabel;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @startDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Date *'**
  String get startDateLabel;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @endDateLabel.
  ///
  /// In en, this message translates to:
  /// **'End Date *'**
  String get endDateLabel;

  /// No description provided for @additionalInstructions.
  ///
  /// In en, this message translates to:
  /// **'Any additional instructions or details...'**
  String get additionalInstructions;

  /// No description provided for @notesOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptionalLabel;

  /// No description provided for @savingMedicine.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingMedicine;

  /// No description provided for @saveMedicine.
  ///
  /// In en, this message translates to:
  /// **'Save Medicine'**
  String get saveMedicine;

  /// No description provided for @beforeMeal.
  ///
  /// In en, this message translates to:
  /// **'Before Meal'**
  String get beforeMeal;

  /// No description provided for @afterMeal.
  ///
  /// In en, this message translates to:
  /// **'After Meal'**
  String get afterMeal;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get tablet;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @syrup.
  ///
  /// In en, this message translates to:
  /// **'Syrup'**
  String get syrup;

  /// No description provided for @injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get injection;

  /// No description provided for @onceADay.
  ///
  /// In en, this message translates to:
  /// **'Once a day'**
  String get onceADay;

  /// No description provided for @twiceADay.
  ///
  /// In en, this message translates to:
  /// **'Twice a day'**
  String get twiceADay;

  /// No description provided for @thriceADay.
  ///
  /// In en, this message translates to:
  /// **'Thrice a day'**
  String get thriceADay;

  /// No description provided for @fourTimesADay.
  ///
  /// In en, this message translates to:
  /// **'Four times a day'**
  String get fourTimesADay;

  /// No description provided for @noDiseases.
  ///
  /// In en, this message translates to:
  /// **'No diseases selected'**
  String get noDiseases;

  /// No description provided for @updateProfileForDiseases.
  ///
  /// In en, this message translates to:
  /// **'Please update your profile to add diseases'**
  String get updateProfileForDiseases;

  /// No description provided for @noRecordsAdded.
  ///
  /// In en, this message translates to:
  /// **'No records added yet'**
  String get noRecordsAdded;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @errorLoadingRecords.
  ///
  /// In en, this message translates to:
  /// **'Error loading records'**
  String get errorLoadingRecords;

  /// No description provided for @heart.
  ///
  /// In en, this message translates to:
  /// **'Heart'**
  String get heart;

  /// No description provided for @addDiabetesRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Diabetes Record'**
  String get addDiabetesRecord;

  /// No description provided for @bloodSugarHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 120'**
  String get bloodSugarHint;

  /// No description provided for @bloodSugarLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Level (mg/dL) *'**
  String get bloodSugarLabel;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get dateLabel;

  /// No description provided for @timeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 08:30 AM'**
  String get timeHint;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get timeLabel;

  /// No description provided for @readingTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reading Type *'**
  String get readingTypeLabel;

  /// No description provided for @fasting.
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get fasting;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @anyAdditionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Any additional notes...'**
  String get anyAdditionalNotes;

  /// No description provided for @savingRecord.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingRecord;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// No description provided for @addHeartRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Heart Record'**
  String get addHeartRecord;

  /// No description provided for @heartRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 72'**
  String get heartRateHint;

  /// No description provided for @heartRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate (bpm) *'**
  String get heartRateLabel;

  /// No description provided for @describeSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Describe any symptoms...'**
  String get describeSymptoms;

  /// No description provided for @symptomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Symptoms *'**
  String get symptomsLabel;

  /// No description provided for @uploadEcgReports.
  ///
  /// In en, this message translates to:
  /// **'Upload ECG/Reports (Optional)'**
  String get uploadEcgReports;

  /// No description provided for @tapToSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to select file'**
  String get tapToSelectFile;

  /// No description provided for @addHypertensionRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Hypertension Record'**
  String get addHypertensionRecord;

  /// No description provided for @systolicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 120'**
  String get systolicHint;

  /// No description provided for @systolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Systolic *'**
  String get systolicLabel;

  /// No description provided for @diastolicHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 80'**
  String get diastolicHint;

  /// No description provided for @diastolicLabel.
  ///
  /// In en, this message translates to:
  /// **'Diastolic *'**
  String get diastolicLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY'**
  String get emergency;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening, {userName} 👋'**
  String goodEvening(String userName);

  /// No description provided for @diabetesLabel.
  ///
  /// In en, this message translates to:
  /// **'Diabetes:'**
  String get diabetesLabel;

  /// No description provided for @bpLabel.
  ///
  /// In en, this message translates to:
  /// **'BP:'**
  String get bpLabel;

  /// No description provided for @medicinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Medicines:'**
  String get medicinesLabel;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @lastReadingNormal.
  ///
  /// In en, this message translates to:
  /// **'Last reading normal'**
  String get lastReadingNormal;

  /// No description provided for @medicinesToday.
  ///
  /// In en, this message translates to:
  /// **'{count} today'**
  String medicinesToday(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
