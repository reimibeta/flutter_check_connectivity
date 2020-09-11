import 'package:connectivity/connectivity.dart';

class FlutterCheckInternet {
  static void onCheck({ onConnected, onDisconnected }) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      onConnected();
    } else {
      onDisconnected();
    }
  }
}