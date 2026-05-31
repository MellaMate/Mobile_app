import 'package:mella_mate_app/core/api_client.dart';
import 'package:mella_mate_app/core/constants.dart';
import 'package:mella_mate_app/features/dashboard/data/model/wallet_model.dart';

class WalletRemoteDataSource {
  final ApiClient _apiClient;

  WalletRemoteDataSource(this._apiClient);

  Future<Wallet> createWallet() async {
    final response = await _apiClient.post(AppConstants.createWallet, body: {});
    return Wallet.fromJson(response);
  }

  Future<Wallet> fetchWallet() async {
    final response = await _apiClient.get(AppConstants.walletBase);
    return Wallet.fromJson(response);
  }

  Future<List<Balance>> fetchBalances(String publicKey) async {
    final response = await _apiClient.get('${AppConstants.getBalances}/$publicKey');
    final List<dynamic> balancesJson = response['balances'] ?? [];
    return balancesJson.map((json) => Balance.fromJson(json)).toList();
  }

  Future<Balance> fetchContractBalance(String publicKey) async {
    final response = await _apiClient.get('${AppConstants.getBalance}/$publicKey');
    return Balance.fromJson(response); // Backend returns {balance: "...", asset_code: "USDC"}
  }
}
