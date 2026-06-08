import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../shared/widgets/custom_button.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/images.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../reset_password/reset_password.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyOTPScreen({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final AuthRepository authRepository = AuthRepository();
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  bool isLoading = false;

  Future<void> handleVerifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      showErrorSnackBar('Please enter complete OTP');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.verifyOTP(
        verificationId: widget.verificationId,
        otp: otp,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ResetPasswordScreen(phoneNumber: widget.phoneNumber),
          ),
        );
      }
    } catch (e) {
      showErrorSnackBar('Invalid OTP. Please try again.');
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ResponsiveSize.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: ResponsiveSize.h(3)),
              Center(child: Image.asset(AppImages.logo, scale: 5)),
              SizedBox(height: ResponsiveSize.h(3)),
              Center(
                child: Text(
                  l10n.verifyOtp,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: ResponsiveSize.h(.5)),
              Center(
                child: Text(
                  "Enter the OTP sent to ${widget.phoneNumber}",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: ResponsiveSize.w(3),
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
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
                  text: isLoading ? l10n.verifying : l10n.verifyOtp,
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.white,
                  onPressed: isLoading ? null : handleVerifyOTP,
                  width: ResponsiveSize.w(25),
                  height: ResponsiveSize.h(.6),
                  borderRadius: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
