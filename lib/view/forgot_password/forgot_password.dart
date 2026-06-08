// lib/view/forgot_password/forgot_password.dart

import 'package:flutter/material.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/validators/validators.dart';
import '../../utils/formatters/formatters.dart';
import '../signin/signin.dart';
import '../verify_otp/verify_otp.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  // lib/view/forgot_password/forgot_password.dart

  Future<void> handleSendOTP() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Format phone number to E.164 format
      String formattedPhone = formatPhoneNumber(phoneController.text.trim());

      await authRepository.sendOTPForPasswordReset(
        phoneNumber: formattedPhone,
        onCodeSent: (verificationId) {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOTPScreen(
                  verificationId: verificationId,
                  phoneNumber: formattedPhone,
                ),
              ),
            );
          }
        },
        onVerificationFailed: (error) {
          showErrorSnackBar(error);
        },
      );
    } catch (e) {
      showErrorSnackBar('Failed to send OTP. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Add this helper method
  String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');

    // If starts with 0, replace with +92
    if (cleaned.startsWith('0')) {
      cleaned = '92' + cleaned.substring(1);
    }

    // If doesn't start with +, add it
    if (!cleaned.startsWith('+')) {
      cleaned = '+' + cleaned;
    }

    return cleaned;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveSize.all(5),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ResponsiveSize.h(3)),
                Center(child: Image.asset(AppImages.logo, scale: 5)),
                SizedBox(height: ResponsiveSize.h(3)),
                Center(
                  child: Text(
                    l10n.forgotPasswordTitle,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(.5)),
                Center(
                  child: Text(
                    l10n.forgotPasswordSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(3)),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF64748B).withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: ResponsiveSize.all(4),
                  child: CustomTextField(
                    hintText: l10n.enterPhoneNumber,
                    labelText: l10n.phoneNumberLabel,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                      color: AppColors.darkGreen,
                    ),
                    prefixPadding: ResponsiveSize.only(left: 2),
                    inputFormatters: AppFormatters.phoneNumberFormatter(),
                    validator: (value) => Validators.validatePhoneNumber(value),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(2)),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF14B8A6).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CustomElevatedButton(
                    text: isLoading ? l10n.sendingOtp : l10n.sendOtp,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.white,
                    onPressed: isLoading ? null : handleSendOTP,
                    width: ResponsiveSize.w(25),
                    height: ResponsiveSize.h(.6),
                    borderRadius: 5,
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.rememberYourPassword,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ).createShader(bounds),
                        child: Text(
                          l10n.signIn,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }
}
