// ignore_for_file: deprecated_member_use

import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:eirs_fsm/data/models/earning_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  
  String selectedFilter = 'today';

  // ✅ Fix - proper typed list
  final List<EarningModel> earnings = [
    EarningModel(
      jobId: "101",
      customer: "Rahul Sharma",
      service: "AC Repair",
      date: DateTime.now(),
      amount: 450,
    ),
    EarningModel(
      jobId: "102",
      customer: "Aarya Yadav",
      service: "Laptop Repair",
      date: DateTime.now().subtract(const Duration(days: 2)),
      amount: 1000,
    ),
    EarningModel(
      jobId: "201",
      customer: "Daini Daniels",
      service: "Plumbing",
      date: DateTime.now().subtract(const Duration(days: 5)),
      amount: 350,
    ),
  ];

  // ✅ Fix - typed properly
  double get totalEarnings =>
      earnings.fold(0.0, (sum, item) => sum + item.amount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Total Earnings Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    AppStrings.totalEarnings,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${totalEarnings.toStringAsFixed(0)}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${earnings.length} ${AppStrings.jobsCompleted}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _filterChip(AppStrings.today, 'today'),
                  const SizedBox(width: 8),
                  _filterChip(AppStrings.thisWeek, 'week'),
                  const SizedBox(width: 8),
                  _filterChip(AppStrings.thisMonth, 'month'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Earnings List
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: earnings.length,
              itemBuilder: (context, index) {
                final item = earnings[index]; // ✅ EarningModel type
                return _earningCard(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Fix - EarningModel type use karo
  Widget _earningCard(EarningModel item) {
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
                color: AppColors.completed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.check_circle, color: AppColors.completed),
            ),
            const SizedBox(width: 12),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.customer, // ✅ Direct property access
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.service, // ✅ Direct property access
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    DateFormat("dd MMM yyyy").format(item.date), // ✅ DateTime type
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            // Amount
            Text(
              "₹${item.amount.toStringAsFixed(0)}", // ✅ double type
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.completed,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Fix - String value compare karo
  Widget _filterChip(String label, String value) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = value);
        // TODO: API call with filter
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}