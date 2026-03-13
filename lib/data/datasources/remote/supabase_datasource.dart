import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../models/user_model.dart';
import '../../models/topic_model.dart';
import '../../models/progress_model.dart';
import '../../../core/errors/exceptions.dart';

class SupabaseDataSource {
  final SupabaseClient _client;

  SupabaseDataSource(this._client);

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw const AuthException('Giriş başarısız');
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) throw const AuthException('Kayıt başarısız');
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<List<TopicModel>> getTopics({String? grade}) async {
    try {
      var query = _client.from('topics').select();
      if (grade != null) {
        query = query.eq('grade', grade);
      }
      final data = await query;
      return data.map((json) => TopicModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<ProgressModel>> getUserProgress(String userId) async {
    try {
      final data = await _client
          .from('progress')
          .select()
          .eq('user_id', userId);
      return data.map((json) => ProgressModel.fromJson(json)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
