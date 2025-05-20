import 'package:news_admin/shared/utils/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseServices {
  Future<void> initSupabase() async {
    /// supabase setup
    await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey);
  }
}
