library flutter_check_connectivity;

import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterCheckConnectivity extends StatefulWidget {

  final Function onConnected;
  final Widget disconnectedWidget;

  FlutterCheckConnectivity({Key key,
    this.onConnected,
    this.disconnectedWidget
  }):super(key: key);

  @override
  _FlutterCheckConnectivityState createState() => _FlutterCheckConnectivityState();
}

class _FlutterCheckConnectivityState extends State<FlutterCheckConnectivity> {
  bool _isConnection = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          _isConnection = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          _isConnection = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          _isConnection = false;
        });
        break;
      default:
        setState((){
          _isConnection = false;
        });
        break;
    }
    // return connection
    widget.onConnected(_isConnection);
  }

  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isConnection == false ? widget.disconnectedWidget : Container();
  }
}

