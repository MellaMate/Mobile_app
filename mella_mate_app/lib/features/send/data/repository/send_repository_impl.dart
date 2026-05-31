import 'package:mella_mate_app/core/api_client.dart';
import 'package:mella_mate_app/core/constants.dart';
import 'package:mella_mate_app/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:mella_mate_app/features/send/data/model/transaction_model.dart';

abstract class SendRepository {
  Future<Map<String, dynamic>> sendPayment(SendPaymentRequest request);
  Future<List<Transaction>> getHistory();
  Future<Map<String, dynamic>> remitToMpesa({
    required double amountUsdc,
    required String phone,
  });
}

class SendRepositoryImpl implements SendRepository {
  final ApiClient _apiClient;
  final DashboardRepository _dashboardRepository;

  SendRepositoryImpl(this._apiClient, this._dashboardRepository);

  @override
  Future<Map<String, dynamic>> sendPayment(SendPaymentRequest request) async {
    final secret = await _dashboardRepository.getStoredSecret();
    final body = request.toJson();
    body['source_secret'] = secret;

    return await _apiClient.post(AppConstants.sendPayment, body: body);
  }

  @override
  Future<List<Transaction>> getHistory() async {
    final response = await _apiClient.get(AppConstants.history);
    List<dynamic> historyJson = [];
    if (response is List) {
      historyJson = response;
    } else if (response is Map && response.containsKey('transactions')) {
      historyJson = response['transactions'];
    }
    return historyJson.map((json) => Transaction.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> remitToMpesa({
    required double amountUsdc,
    required String phone,
  }) async {
    final secret = await _dashboardRepository.getStoredSecret();
    final body = {
      'amount_usdc': amountUsdc,
      'receiver_phone': phone,
      'sender_secret': secret,
    };

    return await _apiClient.post(AppConstants.remit, body: body);
  }
}
