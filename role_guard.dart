import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/admin/screens/admin_login_screen.dart';
import '../constants/app_colors.dart';
import '../services/auth_provider.dart';

class RoleGuard extends ConsumerWidget {
  final Widget child;
  final UserRole requiredRole;

  const RoleGuard({
    super.key,
    required this.child,
    this.requiredRole = UserRole.admin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.creamBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.deepBrown),
        ),
      );
    }

    if (authState.role == requiredRole) {
      return child;
    }

    return const AdminLoginScreen();
  }
}