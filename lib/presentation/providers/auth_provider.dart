import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/user.dart' as entity;
import '../../data/datasources/remote/supabase_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  try {
    return Supabase.instance.client;
  } catch (e) {
    return null;
  }
});

final supabaseDataSourceProvider = Provider<SupabaseDataSource?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client != null ? SupabaseDataSource(client) : null;
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final dataSource = ref.watch(supabaseDataSourceProvider);
  
  SupabaseClient? fallbackClient;
  try {
    fallbackClient = Supabase.instance.client;
  } catch (_) {}

  return AuthRepositoryImpl(
    dataSource ?? (fallbackClient != null ? SupabaseDataSource(fallbackClient) : null),
    client ?? fallbackClient,
  );
});

final authStateProvider = StreamProvider<entity.User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = FutureProvider<entity.User?>((ref) async {
  return ref.watch(authRepositoryProvider).getCurrentUser();
});
