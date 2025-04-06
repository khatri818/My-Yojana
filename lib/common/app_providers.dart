import 'package:provider/provider.dart';
import '../core/manager/loading_providers.dart';
import '../di/injection.dart';
import '../features/auth/presentation/manager/auth_manger.dart';
import '../features/home/presentation/manager/bottom_nav_manager.dart';

class AppProvider {
  static final providers = [

    ChangeNotifierProvider<BottomNavProvider>(
      create: (_) => BottomNavProvider(),
    ),

    ChangeNotifierProvider<AuthManager>(
      create: (_) => Injection.authManager,
    ),

    ChangeNotifierProvider<LoadingProvider>(
      create: (_) => LoadingProvider(),
    ),
  ];
}
