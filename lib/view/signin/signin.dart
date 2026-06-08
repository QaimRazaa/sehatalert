import 'package:flutter/material.dart';
import 'package:sehatalert/view/patient_information/patient_information.dart';
import 'package:sehatalert/view/home/home.dart';
import '../../core/shared_pref/shared_pref.dart';
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
import '../forgot_password/forgot_password.dart';
import '../signup/signup.dart';
import '../../main.dart';

enum LoginMode { email, phone }

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthRepository authRepository = AuthRepository();
  final SharedPreferencesService prefsService = SharedPreferencesService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  LoginMode loginMode = LoginMode.email;
  bool obscurePassword = true;
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  Future<void> loadSavedCredentials() async {
    final savedMode = await prefsService.getSavedLoginMode();

    if (savedMode == 'phone') {
      final shouldRemember = await prefsService.getPhoneRememberMe();
      if (shouldRemember) {
        final credentials = await prefsService.getSavedPhoneCredentials();
        setState(() {
          loginMode = LoginMode.phone;
          rememberMe = true;
          phoneController.text = credentials['phone'] ?? '';
          passwordController.text = credentials['password'] ?? '';
        });
      } else {
        setState(() => loginMode = LoginMode.phone);
      }
    } else {
      final shouldRemember = await prefsService.getRememberMe();
      if (shouldRemember) {
        final credentials = await prefsService.getSavedCredentials();
        setState(() {
          rememberMe = true;
          emailController.text = credentials['email'] ?? '';
          passwordController.text = credentials['password'] ?? '';
        });
      }
    }
  }

  Future<void> handleSignIn() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final user = await authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await prefsService.markAppAsSeen();
      await prefsService.saveLoginMode('email');

      if (rememberMe) {
        await prefsService.saveCredentials(
          emailController.text.trim(),
          passwordController.text,
        );
      } else {
        await prefsService.clearCredentials();
      }

      if (mounted) {
        showSuccessSnackBar('Welcome back!');

        if (user.hasCompletedProfile) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PatientInformation()),
          );
        }
      }
    } catch (e) {
      showErrorSnackBar('An unexpected error occurred. Please try again.');
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

  Future<void> handlePhoneSignIn() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final user = await authRepository.signInWithPhone(
        phoneNumber: phoneController.text.trim(),
        password: passwordController.text,
      );

      await prefsService.markAppAsSeen();
      await prefsService.saveLoginMode('phone');

      if (rememberMe) {
        await prefsService.savePhoneCredentials(
          phoneController.text.trim(),
          passwordController.text,
        );
      } else {
        await prefsService.clearPhoneCredentials();
      }

      if (mounted) {
        showSuccessSnackBar('Welcome back!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                user.hasCompletedProfile ? const HomeScreen() : const PatientInformation(),
          ),
        );
      }
    } catch (e) {
      showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
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
    final isPhone = loginMode == LoginMode.phone;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    l10n.welcomeBack,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(.5)),
                Center(
                  child: Text(
                    l10n.signInSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(3)),

                // Login mode toggle
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      _toggleTab(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        selected: !isPhone,
                        onTap: () => setState(() {
                          loginMode = LoginMode.email;
                          formKey.currentState?.reset();
                        }),
                      ),
                      _toggleTab(
                        label: 'Phone',
                        icon: Icons.phone_outlined,
                        selected: isPhone,
                        onTap: () => setState(() {
                          loginMode = LoginMode.phone;
                          formKey.currentState?.reset();
                        }),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveSize.h(2)),

                // Form fields
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF64748B).withOpacity(0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: ResponsiveSize.all(4),
                  child: isPhone
                      ? Column(
                          children: [
                            CustomTextField(
                              hintText: 'Enter your phone number',
                              labelText: 'Phone Number',
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icon(
                                Icons.phone_outlined,
                                color: AppColors.darkGreen,
                              ),
                              prefixPadding: ResponsiveSize.only(left: 2),
                              inputFormatters: AppFormatters.phoneNumberFormatter(),
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
                              validator: (value) =>
                                  Validators.validateRequired(value, 'Password'),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.darkGreen,
                                  size: ResponsiveSize.icon(2),
                                ),
                                onPressed: () => setState(
                                    () => obscurePassword = !obscurePassword),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            CustomTextField(
                              hintText: l10n.enterYourEmail,
                              labelText: l10n.emailLabel,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: AppColors.darkGreen,
                              ),
                              prefixPadding: ResponsiveSize.only(left: 2),
                              inputFormatters: AppFormatters.emailFormatter(),
                              validator: Validators.validateEmail,
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
                              validator: (value) =>
                                  Validators.validateRequired(value, 'Password'),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.darkGreen,
                                  size: ResponsiveSize.icon(2),
                                ),
                                onPressed: () => setState(
                                    () => obscurePassword = !obscurePassword),
                              ),
                            ),
                          ],
                        ),
                ),

                SizedBox(height: ResponsiveSize.h(1)),

                // Remember Me (both tabs) + Forgot Password (email only)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Transform.scale(
                          scale: 1.1,
                          child: Checkbox(
                            value: rememberMe,
                            onChanged: (value) =>
                                setState(() => rememberMe = value ?? false),
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Text(
                          l10n.rememberMe,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (!isPhone)
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        ),
                        child: Text(
                          l10n.forgotPassword,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(height: ResponsiveSize.h(2)),

                // Primary action button
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                    ),
                    borderRadius: BorderRadius.circular(ResponsiveSize.w(5)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF14B8A6).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CustomElevatedButton(
                    text: isLoading ? l10n.loggingIn : l10n.logIn,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.white,
                    onPressed: isLoading
                        ? null
                        : (isPhone ? handlePhoneSignIn : handleSignIn),
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
                      l10n.dontHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      ),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ).createShader(bounds),
                        child: Text(
                          l10n.register,
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

  Widget _toggleTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.primary : const Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: selected ? AppColors.primary : const Color(0xFF94A3B8),
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
