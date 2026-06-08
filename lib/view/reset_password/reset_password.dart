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

class ResetPasswordScreen extends StatefulWidget {
  final String phoneNumber;

  const ResetPasswordScreen({super.key, required this.phoneNumber});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  Future<void> handleResetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      showErrorSnackBar('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.resetPassword(
        phoneNumber: widget.phoneNumber,
        newPassword: passwordController.text,
      );

      if (mounted) {
        showSuccessSnackBar('Password reset successful');

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          }
        });
      }
    } catch (e) {
      showErrorSnackBar('Failed to reset password. Please try again.');
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
                    l10n.resetPassword,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(.5)),
                Center(
                  child: Text(
                    l10n.enterNewPassword,
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
                  child: Column(
                    children: [
                      CustomTextField(
                        prefixPadding: ResponsiveSize.only(left: 2),
                        hintText: l10n.enterNewPasswordHint,
                        labelText: l10n.newPasswordLabel,
                        controller: passwordController,
                        obscureText: obscurePassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.darkGreen,
                        ),
                        inputFormatters: AppFormatters.passwordFormatter(),
                        validator: Validators.validatePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.darkGreen,
                            size: ResponsiveSize.icon(2),
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: ResponsiveSize.h(1)),
                      CustomTextField(
                        prefixPadding: ResponsiveSize.only(left: 2),
                        hintText: l10n.confirmNewPasswordHint,
                        labelText: l10n.confirmPasswordLabel,
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: AppColors.darkGreen,
                        ),
                        inputFormatters: AppFormatters.passwordFormatter(),
                        validator: (value) => Validators.validateRequired(
                          value,
                          'Confirm Password',
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.darkGreen,
                            size: ResponsiveSize.icon(2),
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                    ],
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
                    text: isLoading ? l10n.resetting : l10n.resetPassword,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.white,
                    onPressed: isLoading ? null : handleResetPassword,
                    width: ResponsiveSize.w(25),
                    height: ResponsiveSize.h(.6),
                    borderRadius: 5,
                  ),
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
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
