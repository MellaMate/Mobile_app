import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/onboarding/presentation/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:mella_mate_app/core/api_client.dart';
import 'package:mella_mate_app/features/auth/data/datalayer/auth_remote_datasource.dart';
import 'package:mella_mate_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:mella_mate_app/features/auth/presentation/pages/signup_page.dart';
import 'package:mella_mate_app/features/dashboard/data/datalayer/wallet_remote_datasource.dart';
import 'package:mella_mate_app/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:mella_mate_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mella_mate_app/features/send/data/repository/send_repository_impl.dart';
import 'package:mella_mate_app/providers/auth_provider.dart';
import 'package:mella_mate_app/providers/wallet_provider.dart';
import 'package:app_links/app_links.dart';

void main() {
  final apiClient = ApiClient();
  
  // Data Sources
  final authRemoteDataSource = AuthRemoteDataSource(apiClient);
  final walletRemoteDataSource = WalletRemoteDataSource(apiClient);
  
  // Repositories
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final dashboardRepository = DashboardRepositoryImpl(walletRemoteDataSource);
  final SendRepository sendRepository = SendRepositoryImpl(apiClient, dashboardRepository);

  final appLinks = AppLinks();
  // Listen for deep links
  appLinks.uriLinkStream.listen((uri) {
    debugPrint('Deep link received: $uri');
    // Handle verification link: https://www.mellamate.tech/verify-email/{token}
    if (uri.path.contains('verify-email')) {
      final token = uri.pathSegments.last;
      debugPrint('Extracted token: $token');
      // In a real app, you would navigate to a verification processing page
      // For now, we'll just log it. The user will be redirected to the app.
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => WalletProvider(dashboardRepository)),
        Provider<SendRepository>.value(value: sendRepository),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MellaMate',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
