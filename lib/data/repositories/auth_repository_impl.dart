import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as entity;
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/supabase_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseDataSource? _remote;
  final SupabaseClient? _supabaseClient;

  AuthRepositoryImpl(this._remote, this._supabaseClient);

  entity.User get _mockUser => entity.User(
        id: 'demo-user',
        email: 'demo@example.com',
        createdAt: DateTime.now(),
      );

  @override
  Future<entity.User> signIn(
      {required String email, required String password}) async {
    if (_remote == null) return _mockUser;
    return _remote.signIn(email: email, password: password);
  }

  @override
  Future<entity.User> signUp(
      {required String email, required String password}) async {
    if (_remote == null) return _mockUser;
    return _remote.signUp(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    if (_remote != null) await _remote.signOut();
  }

  @override
  Future<entity.User?> getCurrentUser() async {
    if (_supabaseClient == null) return _mockUser;
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;
    return entity.User(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  @override
  Stream<entity.User?> get authStateChanges {
    if (_supabaseClient == null) return Stream.value(_mockUser);
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return entity.User(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    });
  }
}
