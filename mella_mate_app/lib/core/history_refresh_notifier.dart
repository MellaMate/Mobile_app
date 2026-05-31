import 'package:flutter/foundation.dart';

class HistoryRefreshNotifier extends ChangeNotifier {
  HistoryRefreshNotifier._();

  static final HistoryRefreshNotifier instance = HistoryRefreshNotifier._();

  void notifyRefresh() {
    notifyListeners();
  }
}
