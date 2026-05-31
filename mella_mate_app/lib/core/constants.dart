class AppConstants {
  static const String baseUrl = 'https://mellamate.onrender.com';
  
  // Auth endpoints
  static const String loginEndpoint = '/token';
  static const String signupEndpoint = '/signup';
  
  // Wallet endpoints
  static const String walletBase = '/api/wallet';
  static const String createWallet = '$walletBase/create';
  static const String getBalance = '$walletBase/balance';
  static const String getBalances = '$walletBase/balances';
  
  // Transaction endpoints
  static const String sendPayment = '$walletBase/send';
  static const String history = '/api/transactions';
  static const String remit = '/api/remit';
  static const String mpesaBuy = '/api/mpesa/buy-usdc';
  static const String mpesaSend = '/api/mpesa/send-etb';
  
  // Storage keys
  static const String tokenKey = 'access_token';
  static const String userKey = 'user_data';
  static const String secretKey = 'stellar_secret';
}
