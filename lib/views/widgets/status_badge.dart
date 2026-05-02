import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/data/models/job_model.dart';
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final JobStatus status;

  const StatusBadge({super.key,required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String text;

    switch(status){
      case JobStatus.pending:
        bgColor = AppColors.pending.withOpacity(0.1);
        textColor = AppColors.pending;
        text = "PENDING";
        break;
      case JobStatus.accepted:
        bgColor = AppColors.accepted.withOpacity(0.1);
        textColor = AppColors.accepted;
        text = "ACCEPTED";
        break;
      case JobStatus.inProgress:
        bgColor = AppColors.inProgress.withOpacity(0.1);
        textColor = AppColors.inProgress;
        text = "IN PROGRESS";
        break;
      case JobStatus.completed:
        bgColor = AppColors.completed.withOpacity(0.1);
        textColor = AppColors.completed;
        text = "COMPLETED";
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}