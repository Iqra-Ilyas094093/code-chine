import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/viewmodels/auth_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();  // watch, not read — rebuilds on user change
    final user = vm.currentUser;               // the real UserModel from Firestore
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;


    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? size.width * 0.15 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ── Top Bar ──────────────────────────────────
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        // Show real name, fallback gracefully
                        user?.name ?? 'Welcome!',
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // ... notification bell stays same ...
                  // Avatar — show first letter of name
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        // First letter of their name as avatar
                        (user?.name.isNotEmpty == true)
                            ? user!.name[0].toUpperCase()
                            : 'U',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ── User Info Card (new — shows Firestore data) ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          (user?.name.isNotEmpty == true)
                              ? user!.name[0].toUpperCase() : 'U',
                          style: GoogleFonts.poppins(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? '—',
                            style: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary),
                          ),
                          Text(
                            user?.email ?? '—',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                          if (user?.businessName?.isNotEmpty == true)
                            Text(
                              user!.businessName!,
                              style: GoogleFonts.poppins(
                                  fontSize: 11, color: AppColors.primary,
                                  fontWeight: FontWeight.w500),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF43C59E).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('Active',
                              style: GoogleFonts.poppins(
                                  color: const Color(0xFF43C59E), fontSize: 10,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          // Show join date from Firestore
                          'Joined ${_formatDate(user?.createdAt)}',
                          style: GoogleFonts.poppins(
                              fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              // ── Logout Button ────────────────────────────
              GestureDetector(
                onTap: () async {
                  // Navigator.pop(context);          // Close dialog first
                  await vm.logout();           // Call real Firebase logout
                  // vm.logout() already sets screen to onboarding and clears user
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.red.shade100, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded,
                          color: Colors.red.shade400, size: 20),
                      const SizedBox(width: 10),
                      Text('Log Out',
                          style: GoogleFonts.poppins(
                              color: Colors.red.shade400,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[date.month - 1]} ${date.year}';
  }
}