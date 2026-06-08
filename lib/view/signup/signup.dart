import 'package:flutter/material.dart';
import 'package:sehatalert/utils/constants/images.dart';
import '../../core/shared_pref/shared_pref.dart';
import '../../data/repository/authentication/authentication_repository.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_textfield.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_styles.dart';
import 'package:sehatalert/l10n/app_localizations.dart';
import '../../utils/device/responsive_size.dart';
import '../../utils/exceptions/exceptions.dart';
import '../../utils/validators/validators.dart';
import '../../utils/formatters/formatters.dart';
import '../signin/signin.dart';
import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool acceptTerms = false;
  bool isLoading = false;

  Future<void> handleSignUp() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms) {
      showErrorSnackBar('Please accept the Terms & Conditions');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await authRepository.signUp(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
      );

      await SharedPreferencesService().markAppAsSeen();

      if (mounted) {
        showSuccessSnackBar('Account created successfully!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    } on AuthException catch (e) {
      showErrorSnackBar(e.message);
    } on FirestoreException catch (e) {
      showErrorSnackBar(e.message);
    } catch (e) {
      showErrorSnackBar('Error: $e');
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: ResponsiveSize.all(5),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: PopupMenuButton<String>(
                        color: Colors.white,
                        onSelected: (value) {
                          MyApp.setLocale(context, Locale(value));
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'en', child: Text('English')),
                          const PopupMenuItem(value: 'ur', child: Text('اردو')),
                        ],
                        child: Icon(
                          Icons.language,
                          color: const Color(0xFF10B981),
                          size: ResponsiveSize.icon(2.5),
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1)),
                    Center(child: Image.asset(AppImages.logo, scale: 5)),
                    SizedBox(height: ResponsiveSize.h(3)),
                    Center(
                      child: Text(
                        l10n.healthProtected,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(3)),
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                      ).createShader(bounds),
                      child: Text(
                        l10n.createAccount,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(.5)),
                    Text(
                      l10n.signUpSubtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(2)),
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
                            hintText: l10n.enterFullName,
                            labelText: l10n.fullNameLabel,
                            controller: fullNameController,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.darkGreen,
                            ),
                            inputFormatters: AppFormatters.nameFormatter(),
                            validator: Validators.validateFullName,
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          CustomTextField(
                            prefixPadding: ResponsiveSize.only(left: 2),
                            hintText: l10n.enterYourEmail,
                            labelText: l10n.emailLabel,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.darkGreen,
                            ),
                            inputFormatters: AppFormatters.emailFormatter(),
                            validator: Validators.validateEmail,
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          CustomTextField(
                            hintText: l10n.enterPhoneNumber,
                            labelText: l10n.phoneNumberLabel,
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppColors.darkGreen,
                            ),
                            prefixPadding: ResponsiveSize.only(left: 2),
                            inputFormatters:
                                AppFormatters.phoneNumberFormatter(),
                            validator: Validators.validatePhoneNumber,
                          ),
                          SizedBox(height: ResponsiveSize.h(1)),
                          CustomTextField(
                            prefixPadding: ResponsiveSize.only(left: 2),
                            hintText: l10n.enterYourPassword,
                            labelText: l10n.passwordLabel,
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
                            hintText: l10n.confirmYourPassword,
                            labelText: l10n.confirmPasswordLabel,
                            controller: confirmPasswordController,
                            obscureText: obscureConfirmPassword,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: AppColors.darkGreen,
                            ),
                            inputFormatters: AppFormatters.passwordFormatter(),
                            validator: (value) =>
                                Validators.validateConfirmPassword(
                                  value,
                                  passwordController.text,
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
                                  obscureConfirmPassword =
                                      !obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1)),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: acceptTerms
                              ? Color(0xFF14B8A6).withOpacity(0.3)
                              : Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: acceptTerms
                                ? Color(0xFF14B8A6).withOpacity(0.1)
                                : Color(0xFF64748B).withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: ResponsiveSize.symmetric(h: 2, v: 1),
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.1,
                            child: Checkbox(
                              value: acceptTerms,
                              onChanged: (value) {
                                setState(() {
                                  acceptTerms = value ?? false;
                                });
                              },
                              activeColor: Color(0xFF14B8A6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              l10n.termsAndConditions,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textDark,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1.5)),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                        ),
                        borderRadius: BorderRadius.circular(
                          ResponsiveSize.w(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF14B8A6).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CustomElevatedButton(
                        text: isLoading ? l10n.registering : l10n.register,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.white,
                        onPressed: isLoading ? null : handleSignUp,
                        width: ResponsiveSize.w(25),
                        height: ResponsiveSize.h(.6),
                        borderRadius: 5,
                      ),
                    ),
                    SizedBox(height: ResponsiveSize.h(1.5)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.alreadyHaveAccount,
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
                              colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                            ).createShader(bounds),
                            child: Text(
                              l10n.logIn,
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
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
