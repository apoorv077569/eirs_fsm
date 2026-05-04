import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final RxBool isInternetAvailable = true.obs;
  bool _isDialogOpen = false;

  Future<NetworkService> init() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _checkInitialConnection();
    _listenConnectionChanges();
    return this;
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _listenConnectionChanges() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    isInternetAvailable.value = hasConnection;

    if (!hasConnection) {
      _showNoInternetDialog();
    } else {
      _closeDialogIfOpen();
    }
  }

  void _showNoInternetDialog() {
    if (_isDialogOpen) return;

    if(Get.context == null) return;
    if(Get.isDialogOpen == true) return;
    if(Get.isBottomSheetOpen == true) return;

    _isDialogOpen = true;

    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.wifi_off, color: Colors.red),
              SizedBox(width: 8),
              Text("No Internet"),
            ],
          ),
          content: const Text("Please connect to internet."),
          actions: [
            TextButton(
              onPressed: () async {
                final result = await _connectivity.checkConnectivity();
                _updateConnectionStatus(result);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _closeDialogIfOpen() {
    if (_isDialogOpen && Get.isDialogOpen == true) {
      Get.back();
      _isDialogOpen = false;
    } else {
      _isDialogOpen = false;
    }
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}