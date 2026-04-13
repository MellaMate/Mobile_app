import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mella_mate_app/core/constants.dart';
import 'package:mella_mate_app/features/dashboard/data/datalayer/wallet_remote_datasource.dart';
import 'package:mella_mate_app/features/dashboard/data/model/wallet_model.dart';

abstract class DashboardRepository {
  Future<Wallet> getWallet();
  Future<List<Balance>> getBalances(String publicKey);
  Future<Balance> getUSDCBalance(String publicKey);
  Future<String?> getStoredSecret();
}

class DashboardRepositoryImpl implements DashboardRepository {
  final WalletRemoteDataSource _remoteDataSource;
  final _storage = const FlutterSecureStorage();

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Wallet> getWallet() async {
    try {
      final wallet = await _remoteDataSource.fetchWallet();
      // If backend returns secret, store it locally
      if (wallet.secretKey != null) {
        await _storage.write(key: AppConstants.secretKey, value: wallet.secretKey);
      }
      return wallet;
    } catch (e) {
      if (e.toString().contains('404')) {
        // Wallet doesn't exist, create one
        final newWallet = await _remoteDataSource.createWallet();
        if (newWallet.secretKey != null) {
          await _storage.write(key: AppConstants.secretKey, value: newWallet.secretKey);
        }
        return newWallet;
      }
      rethrow;
    }
  }

  @override
  Future<List<Balance>> getBalances(String publicKey) async {
    return await _remoteDataSource.fetchBalances(publicKey);
  }

  @override
  Future<Balance> getUSDCBalance(String publicKey) async {
    return await _remoteDataSource.fetchContractBalance(publicKey);
  }

  @override
  Future<String?> getStoredSecret() async {
    return await _storage.read(key: AppConstants.secretKey);
  }
}
