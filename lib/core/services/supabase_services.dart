import 'package:news_admin/shared/utils/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaBaseServices {
  static final SupaBaseServices _instance = SupaBaseServices._internal();

  factory SupaBaseServices() => _instance;

  SupaBaseServices._internal();

  late final SupabaseClient client;

  bool _initialized = false;

  Future<void> initSupabase() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );

    client = Supabase.instance.client;
    _initialized = true;
  }
}

