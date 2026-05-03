import 'package:eirs_fsm/data/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = 0.0.obs;
  var transactions = <WalletTransaction>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }

  void loadMockData() {
    balance.value = 4500.0;

    transactions.addAll([
      WalletTransaction(
        id: "TXN001",
        title: "AC Repair - Rahul Sharma",
        description: "Job #101 completed",
        amount: 450.0,
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        type: TransactionType.credit,
        jobId: "101",
      ),
      WalletTransaction(
        id: "TXN002",
        title: "Laptop Repair - Aarya Yadav",
        description: "Job #102 completed",
        amount: 1000.0,
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        type: TransactionType.credit,
        jobId: "102",
      ),
      WalletTransaction(
        id: "TXN003",
        title: "Withdrawal to Bank",
        description: "Transfer to HDFC ****1234",
        amount: 500.0,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        type: TransactionType.debit,
      ),
      WalletTransaction(
        id: "TXN004",
        title: "Plumbing - Daini Daniels",
        description: "Job #201 completed",
        amount: 350.0,
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        type: TransactionType.credit,
        jobId: "201",
      ),
      WalletTransaction(
        id: "TXN005",
        title: "Money Added",
        description: "Added via UPI",
        amount: 2000.0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        type: TransactionType.credit,
      ),
      WalletTransaction(
        id: "TXN006",
        title: "Withdrawal to Bank",
        description: "Transfer to SBI ****5678",
        amount: 800.0,
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        type: TransactionType.debit,
      ),
    ]);
  }

  // Job complete hone ke baad wallet update hoga
  void addJobEarning(String jobId, String customerName, double amount) {
    balance.value += amount;

    transactions.insert(
      0,
      WalletTransaction(
        id: "TXN${DateTime.now().millisecondsSinceEpoch}",
        title: "Job #$jobId - $customerName",
        description: "Job completed successfully",
        amount: amount,
        dateTime: DateTime.now(),
        type: TransactionType.credit,
        jobId: jobId,
      ),
    );

    transactions.refresh();

    debugPrint("💰 Wallet updated: +₹$amount | Balance: ₹${balance.value}");
  }

  // Money add karo (dummy)
  void addMoney(double amount) {
    balance.value += amount;

    transactions.insert(
      0,
      WalletTransaction(
        id: "TXN${DateTime.now().millisecondsSinceEpoch}",
        title: "Money Added",
        description: "Added via UPI",
        amount: amount,
        dateTime: DateTime.now(),
        type: TransactionType.credit,
      ),
    );

    transactions.refresh();

    Get.snackbar(
      "Success",
      "₹${amount.toStringAsFixed(0)} added to wallet",
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Withdraw karo (dummy)
  void withdrawMoney(double amount) {
    if (amount > balance.value) {
      Get.snackbar(
        "Error",
        "Insufficient balance",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    balance.value -= amount;

    transactions.insert(
      0,
      WalletTransaction(
        id: "TXN${DateTime.now().millisecondsSinceEpoch}",
        title: "Withdrawal to Bank",
        description: "Transfer to bank account",
        amount: amount,
        dateTime: DateTime.now(),
        type: TransactionType.debit,
      ),
    );

    transactions.refresh();

    Get.snackbar(
      "Success",
      "₹${amount.toStringAsFixed(0)} withdrawn from wallet",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  double get totalEarnings => transactions
      .where((t) => t.type == TransactionType.credit)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalWithdrawals => transactions
      .where((t) => t.type == TransactionType.debit)
      .fold(0.0, (sum, t) => sum + t.amount);
}