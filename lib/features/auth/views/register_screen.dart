import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        size: 18, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  "Lets Register\nAccount",
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 36 : 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Hello user, you have a greatful journey",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 36),
                AuthTextField(
                  controller: vm.registerNameController,
                  hint: 'Name',
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: vm.registerBusinessController,
                  hint: 'Business name',
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: vm.registerPhoneController,
                  hint: 'Phone',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: vm.registerEmailController,
                  hint: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                AuthTextField(
                  controller: vm.registerPasswordController,
                  hint: 'Password',
                  obscureText: vm.obscureRegisterPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      vm.obscureRegisterPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.hint,
                      size: 20,
                    ),
                    onPressed: vm.toggleRegisterPasswordVisibility,
                  ),
                ),
                const SizedBox(height: 32),
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
                          color: Colors.red.shade700, fontSize: 13),
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
                      '✓ Account created successfully!',
                      style: GoogleFonts.poppins(
                          color: Colors.green.shade700, fontSize: 13),
                    ),
                  ),
                PrimaryButton(
                  text: 'Sign Up',
                  isLoading: vm.state == AuthState.loading,
                  onPressed: vm.register,
                ),
                const SizedBox(height: 28),
                RichLinkText(
                  normalText: 'Already have an account ? ',
                  linkText: 'Login',
                  onLinkTap: () => vm.goToScreen(AuthScreen.signIn),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}