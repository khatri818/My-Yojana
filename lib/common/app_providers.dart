import 'package:my_yojana/core/services/storage_service.dart';
import 'package:my_yojana/features/home/presentation/manager/scheme_manger.dart';
import 'package:provider/provider.dart';
import '../core/manager/loading_providers.dart';
import '../di/injection.dart';
import '../features/auth/presentation/manager/auth_manger.dart';
import '../features/home/presentation/manager/bottom_nav_manager.dart';
import '../features/user/data/models/user_model.dart';
import '../features/user/presentation/manager/user_manager.dart';

class AppProvider {
  static final providers = [

    ChangeNotifierProvider<BottomNavProvider>(
      create: (_) => BottomNavProvider(),
    ),

    ChangeNotifierProvider<AuthManager>(
      create: (_) => Injection.authManager,
    ),

    ChangeNotifierProvider<UserManager>(
      create: (_) => Injection.userManager,
    ),

    ChangeNotifierProvider<LoadingProvider>(
      create: (_) => LoadingProvider(),
    ),

    ChangeNotifierProvider<SchemeManager>(
      create: (_) => Injection.schemeManager,
    ),

  ];
}
