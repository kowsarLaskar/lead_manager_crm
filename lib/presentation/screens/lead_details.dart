import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';
import 'package:lead_manager_crm/presentation/screens/add_edit_screen.dart';
import 'package:lead_manager_crm/presentation/widgets/status_badge.dart';
import 'package:lead_manager_crm/service/providers/lead_provider.dart';
import '../../../core/utils/status_helper.dart';
import '../../../data/models/lead_model.dart';

class LeadDetailsScreen extends ConsumerWidget {
  final LeadModel lead;

  const LeadDetailsScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch specific lead for real-time updates
    final currentLead = ref
        .watch(leadProvider)
        .firstWhere((element) => element.id == lead.id, orElse: () => lead);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic styles based on theme
    final headerColor = isDark ? Colors.white : AppColors.cTextBlue;
    final cardBgColor = isDark ? AppColors.surfaceDark : Colors.white;
    final subTextColor = isDark ? Colors.grey[400] : AppColors.cTextBlue;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: headerColor),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Lead Details',
          style: TextStyle(color: headerColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: headerColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditLeadScreen(lead: currentLead),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () =>
                _showDeleteConfirmation(context, ref, currentLead.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          children: [
            // 1. PROFILE SECTION
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppColors.cTextBlue,
                  child: Text(
                    currentLead.name[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentLead.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: headerColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StatusBadge(status: currentLead.status),
                    ],
                  ),
                ),
                // Action Icons
                _buildCircleIcon(Icons.phone, AppColors.cGreen),
                const SizedBox(width: 10),
                _buildCircleIcon(Icons.chat_bubble, AppColors.cCyan),
              ],
            ),

            const SizedBox(height: 30),

            // 2. STATUS UPDATE CARD (Replaces Tasks/Done)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: isDark ? Border.all(color: Colors.grey[800]!) : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Update Status",
                        style: TextStyle(
                          color: headerColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.touch_app, color: AppColors.cOrange, size: 20),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: LeadStatus.values.map((status) {
                      final isActive = status.name == currentLead.status;
                      return ChoiceChip(
                        label: Text(status.name),
                        selected: isActive,
                        selectedColor: AppColors.cYellow.withOpacity(0.2),
                        backgroundColor: isDark
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        side: BorderSide.none,
                        labelStyle: TextStyle(
                          color: isActive
                              ? AppColors.cOrange
                              : (isDark ? Colors.white70 : Colors.grey[700]),
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            ref
                                .read(leadProvider.notifier)
                                .updateLead(
                                  currentLead.copyWith(status: status.name),
                                );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. TABS HEADER
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Info & Notes",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: headerColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColors.cYellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 1,
              color: AppColors.cYellow.withOpacity(0.5),
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            // 4. INFO CARDS
            _buildInfoCard(
              title: "Contact Details",
              content: currentLead.contact,
              icon: Icons.contact_phone,
              bgColor: isDark ? Colors.grey[900]! : AppColors.cBlueLight,
              titleColor: AppColors.cOrange,
              textColor: isDark ? Colors.white70 : AppColors.cTextBlue,
            ),

            if (currentLead.notes.isNotEmpty)
              _buildInfoCard(
                title: "Notes",
                content: currentLead.notes,
                icon: Icons.notes,
                bgColor: isDark ? Colors.grey[900]! : AppColors.cBlueLight,
                titleColor: AppColors.cTextBlue,
                textColor: isDark ? Colors.grey[400]! : const Color(0xFF547298),
              ),

            // Dummy History Item
            _buildInfoCard(
              title: "Previous Interaction",
              content:
                  "Client requested a callback regarding the premium plan pricing.",
              icon: Icons.history,
              bgColor: isDark ? Colors.grey[900]! : AppColors.cBlueLight,
              titleColor: Colors.grey,
              textColor: isDark ? Colors.grey[500]! : Colors.grey[600]!,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required Color bgColor,
    required Color titleColor,
    required Color textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(icon, color: AppColors.cYellow, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: textColor, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    String leadId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 30,
            ),
            SizedBox(width: 10),
            Text("Delete Lead?"),
          ],
        ),
        content: const Text(
          "Are you sure you want to remove this lead? This action cannot be undone.",
          style: TextStyle(fontSize: 16),
        ),
        actionsPadding: const EdgeInsets.all(20),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              ref.read(leadProvider.notifier).deleteLead(leadId);
              Navigator.pop(ctx); // Close Dialog
              Navigator.pop(context); // Go back to Dashboard
            },
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
