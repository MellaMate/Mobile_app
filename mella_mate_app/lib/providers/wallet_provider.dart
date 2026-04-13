import 'package:flutter/material.dart';
import 'package:mella_mate_app/features/dashboard/data/model/wallet_model.dart';
import 'package:mella_mate_app/features/dashboard/data/repository/dashboard_repository_impl.dart';

class WalletProvider extends ChangeNotifier {
  final DashboardRepository _repository;

  Wallet? _wallet;
  List<Balance> _balances = [];
  Balance? _usdcBalance;
  bool _isLoading = false;
  String? _error;

  WalletProvider(this._repository);

  Wallet? get wallet => _wallet;
  List<Balance> get balances => _balances;
  Balance? get usdcBalance => _usdcBalance;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadWalletData() async {
    _setLoading(true);
    _error = null;
    try {
      _wallet = await _repository.getWallet();
      if (_wallet != null) {
        _balances = await _repository.getBalances(_wallet!.publicKey);
        _usdcBalance = await _repository.getUSDCBalance(_wallet!.publicKey);
      }
      _setLoading(false);
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
    }
  }

  Future<void> refreshBalance() async {
    if (_wallet == null) return;
    try {
      _balances = await _repository.getBalances(_wallet!.publicKey);
      _usdcBalance = await _repository.getUSDCBalance(_wallet!.publicKey);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
