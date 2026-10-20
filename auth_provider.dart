import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_service.dart';

enum UserRole { guest, customer, admin }

class AuthState {
  final User? user;
  final UserRole role;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.role = UserRole.guest,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    UserRole? role,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String ownerEmail = 'paljewellers000@gmail.com';

  AuthNotifier() : super(const AuthState()) {
    _initAuthListener();
  }

  void _initAuthListener() {
    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        state = const AuthState(role: UserRole.guest);
      } else {
        final role = await _determineUserRole(user);
        state = AuthState(user: user, role: role);
      }
    });
  }

  Future<UserRole> _determineUserRole(User user) async {
    if (user.email?.toLowerCase().trim() == ownerEmail) {
      return UserRole.admin;
    }

    final idTokenResult = await user.getIdTokenResult(true);
    if (idTokenResult.claims?['role'] == 'admin') {
      return UserRole.admin;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data()?['role'] == 'admin') {
        return UserRole.admin;
      }
    } catch (_) {}

    return UserRole.customer;
  }

  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) throw Exception("Authentication failed");

      final role = await _determineUserRole(user);

      if (role != UserRole.admin) {
        await _auth.signOut();
        state = const AuthState(
          role: UserRole.guest,
          errorMessage: "Access Denied: This account lacks administrative privileges.",
        );
        return false;
      }

      state = AuthState(user: user, role: UserRole.admin, isLoading: false);
      await NotificationService().registerAdminToken();
      return true;
    } on FirebaseAuthException catch (e) {
      String message = "Authentication failed.";
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        message = "Invalid email or credentials.";
      } else if (e.code == 'too-many-requests') {
        message = "Too many failed attempts. Try again later.";
      }
      state = state.copyWith(isLoading: false, errorMessage: message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await NotificationService().removeAdminToken();
    await _auth.signOut();
    state = const AuthState(role: UserRole.guest);
  }
}