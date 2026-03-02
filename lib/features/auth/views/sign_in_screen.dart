import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? size.width * 0.2 : 28,
              vertical: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => vm.goToScreen(AuthScreen.onboarding),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  "Lets Sign you in",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 36 : 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome Back,\nYou have been missed",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),
                AuthTextField(
                  controller: vm.signInEmailController,
                  hint: 'Email, phone & username',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: vm.signInPasswordController,
                  hint: 'Password',
                  obscureText: vm.obscureSignInPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.obscureSignInPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.hint,
                      size: 20,
                    ),
                    onPressed: vm.toggleSignInPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password ?',
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                if (vm.state == AuthState.error && vm.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      vm.errorMessage!,
                      style: GoogleFonts.poppins(
                        color: Colors.red.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (vm.state == AuthState.success)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      '✓ Signed in successfully!',
                      style: GoogleFonts.poppins(
                        color: Colors.green.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                PrimaryButton(
                  text: 'Sign in',
                  isLoading: vm.state == AuthState.loading,
                  onPressed: vm.signIn,
                ),
                const SizedBox(height: 28),
                const DividerWithText(text: 'or'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SocialButton(
                      icon: const Text(
                        'G',
                        style: TextStyle(
                          color: AppColors.google,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      onPressed: () => vm.signInWithGoogle(),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                RichLinkText(
                  normalText: "Don't have an account ? ",
                  linkText: 'Register Now',
                  onLinkTap: () => vm.goToScreen(AuthScreen.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
