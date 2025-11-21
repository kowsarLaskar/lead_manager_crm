import 'package:flutter/material.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';
import 'package:lead_manager_crm/presentation/screens/lead_details.dart';
import '../../core/utils/status_helper.dart';
import '../../data/models/lead_model.dart';
import 'status_badge.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;

  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final statusEnum = StatusHelper.stringToStatus(lead.status);
    final statusColor = StatusHelper.getColor(statusEnum);
    final theme = Theme.of(context); // Access current theme data

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          // ✦ DYNAMIC COLOR: Uses theme cardColor (White in Light, Dark Grey in Dark)
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LeadDetailsScreen(lead: lead),
                ),
              );
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Color Strip
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),

                  // 2. Main Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  lead.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              StatusBadge(status: lead.status),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Contact
                          Row(
                            children: [
                              Icon(
                                Icons.contact_phone_outlined,
                                size: 16,
                                // ✦ DYNAMIC ICON COLOR
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  lead.contact,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Notes
                          if (lead.notes.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notes_rounded,
                                  size: 16,
                                  color: theme.textTheme.bodyMedium?.color
                                      ?.withOpacity(0.5),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    lead.notes,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 3. Arrow
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: theme.dividerColor, // Dynamic divider color
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
