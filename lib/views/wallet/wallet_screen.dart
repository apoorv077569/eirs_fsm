import 'package:eirs_fsm/controllers/wallet_controller.dart';
import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/data/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Wallet"),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => SingleChildScrollView(
        child: Column(
          children: [
            // ═══════════════════════════════════════
            // 💰 BALANCE CARD
            // ═══════════════════════════════════════
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A5F), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Available Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${controller.balance.value.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statItem(
                        "Total Earned",
                        "₹${controller.totalEarnings.toStringAsFixed(0)}",
                        Icons.arrow_downward,
                        Colors.greenAccent,
                      ),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _statItem(
                        "Withdrawn",
                        "₹${controller.totalWithdrawals.toStringAsFixed(0)}",
                        Icons.arrow_upward,
                        Colors.orangeAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ═══════════════════════════════════════
            // 🔘 ADD & WITHDRAW BUTTONS
            // ═══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Add Money Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddMoneyDialog(controller),
                      icon: const Icon(Icons.add_circle, color: Colors.white),
                      label: const Text(
                        "Add Money",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Withdraw Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showWithdrawDialog(controller),
                      icon: const Icon(Icons.account_balance, color: Colors.white),
                      label: const Text(
                        "Withdraw",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ═══════════════════════════════════════
            // 📜 TRANSACTIONS HEADER
            // ═══════════════════════════════════════
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Transactions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${controller.transactions.length} total",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // ═══════════════════════════════════════
            // 📜 TRANSACTIONS LIST
            // ═══════════════════════════════════════
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.transactions.length,
              itemBuilder: (context, index) {
                final txn = controller.transactions[index];
                return _transactionCard(txn);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      )),
    );
  }

  // ─── Stat Item ───
  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  // ─── Transaction Card ───
  Widget _transactionCard(WalletTransaction txn) {
    final isCredit = txn.type == TransactionType.credit;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCredit
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    txn.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    txn.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat("dd MMM, hh:mm a").format(txn.dateTime),
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              "${isCredit ? '+' : '-'} ₹${txn.amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Add Money Dialog ───
  void _showAddMoneyDialog(WalletController controller) {
    final amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Add Money"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            // Quick Amount Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _quickAmountChip("₹500", 500, amountController),
                _quickAmountChip("₹1000", 1000, amountController),
                _quickAmountChip("₹2000", 2000, amountController),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                controller.addMoney(amount);
                Get.back();
              } else {
                Get.snackbar("Error", "Enter valid amount");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Add", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Withdraw Dialog ───
  void _showWithdrawDialog(WalletController controller) {
    final amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Withdraw Money"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Balance: ₹${controller.balance.value.toStringAsFixed(0)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0) {
                controller.withdrawMoney(amount);
                Get.back();
              } else {
                Get.snackbar("Error", "Enter valid amount");
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("Withdraw", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Quick Amount Chip ───
  Widget _quickAmountChip(
    String label,
    double amount,
    TextEditingController controller,
  ) {
    return GestureDetector(
      onTap: () => controller.text = amount.toStringAsFixed(0),
      child: Chip(
        label: Text(label),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}