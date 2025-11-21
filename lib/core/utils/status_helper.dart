import 'package:flutter/material.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';

enum LeadStatus { New, Contacted, Converted, Lost }

class StatusHelper {
  static String statusToString(LeadStatus status) => status.name;

  static LeadStatus stringToStatus(String status) {
    return LeadStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => LeadStatus.New,
    );
  }

  static Color getColor(LeadStatus status) {
    switch (status) {
      case LeadStatus.New:
        return AppColors.statusNew;
      case LeadStatus.Contacted:
        return AppColors.statusContacted;
      case LeadStatus.Converted:
        return AppColors.statusConverted;
      case LeadStatus.Lost:
        return AppColors.statusLost;
    }
  }
}
