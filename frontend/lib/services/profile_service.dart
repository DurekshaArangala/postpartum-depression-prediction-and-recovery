
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getOrCreateProfile() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final existing = await _supabase
        .from('profiles')
        .select('id, full_name, onboarding_completed')
        .eq('id', user.id)
        .maybeSingle();

    if (existing != null) {
      return existing;
    }

    final fullName =
        user.userMetadata?['full_name'] as String? ?? 'Friend';

    return await _supabase
        .from('profiles')
        .insert({
          'id': user.id,
          'full_name': fullName,
          'onboarding_completed': false,
        })
        .select('id, full_name, onboarding_completed')
        .single();
  }

  Future<bool> hasCompletedOnboarding() async {
    final profile = await getOrCreateProfile();

    return profile['onboarding_completed'] == true;
  }
}
