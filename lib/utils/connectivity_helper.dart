import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fimber/fimber.dart';

class ConnectivityHelper {
  static final ConnectivityHelper _singleton = ConnectivityHelper._internal();

  factory ConnectivityHelper() {
    return _singleton;
  }

  ConnectivityHelper._internal();

  Future<bool> checkConnectivityResult() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fimber.d("No Connectivity.");
      // Fluttertoast.showToast(msg: "No Connectivity");
    } else if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      Fimber.d("Mobile Network.");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      Fimber.d("Wifi Network.");
      return true;
    }
    // else if (connectivityResult == ConnectivityResult.vpn) {
    // // I am connected to a VPN network.
    //   Fimber.d("VPN Network.");
    //   return true;
    // }
    return false;
  }
}
