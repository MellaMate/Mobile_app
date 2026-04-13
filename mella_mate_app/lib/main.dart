import 'package:flutter/material.dart';
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

void main() {
  final apiClient = ApiClient();
  
  // Data Sources
  final authRemoteDataSource = AuthRemoteDataSource(apiClient);
  final walletRemoteDataSource = WalletRemoteDataSource(apiClient);
  
  // Repositories
  final authRepository = AuthRepositoryImpl(authRemoteDataSource);
  final dashboardRepository = DashboardRepositoryImpl(walletRemoteDataSource);
  final sendRepository = SendRepositoryImpl(apiClient, dashboardRepository);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => WalletProvider(dashboardRepository)),
        Provider.value(value: sendRepository),
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
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return const DashboardPage();
          }
          return const SignupPage();
        },
      ),
    );
  }
}
