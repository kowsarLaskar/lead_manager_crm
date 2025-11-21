import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lead_manager_crm/core/constants/app_color.dart';
import 'package:lead_manager_crm/data/models/lead_model.dart';
import 'package:lead_manager_crm/presentation/screens/add_edit_screen.dart';
import 'package:lead_manager_crm/presentation/widgets/lead_card.dart';
import 'package:lead_manager_crm/service/providers/filter_provider.dart';
import 'package:lead_manager_crm/service/providers/lead_provider.dart';
import 'package:lead_manager_crm/service/providers/theme_providers.dart';
import '../../../core/utils/status_helper.dart';
import 'dart:convert';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

class LeadDashboardScreen extends ConsumerStatefulWidget {
  const LeadDashboardScreen({super.key});

  @override
  ConsumerState<LeadDashboardScreen> createState() =>
      _LeadDashboardScreenState();
}

class _LeadDashboardScreenState extends ConsumerState<LeadDashboardScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ✦ UPDATED EXPORT LOGIC (Uses Share Sheet)
  Future<void> _exportLeads(List<LeadModel> leads) async {
    if (leads.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No leads to export!")));
      return;
    }

    try {
      // 1. Get Temporary Directory (Safe sandbox)
      final directory = await getTemporaryDirectory();
      final fileName =
          'leads_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final path = '${directory.path}/$fileName';
      final file = File(path);

      // 2. Convert to JSON and Write to Temp File
      final jsonString = jsonEncode(leads.map((e) => e.toMap()).toList());
      await file.writeAsString(jsonString);

      // 3. Share the File (Opens system dialog to Save/Email/Share)
      // This bypasses the need for complex storage permissions
      final result = await Share.shareXFiles(
        [XFile(path)],
        subject: 'CRM Leads Export',
        text: 'Here is the JSON export of your leads.',
      );

      if (result.status == ShareResultStatus.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Export successful!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Export failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leads = ref.watch(filteredLeadsProvider);
    final allLeads = ref.watch(
      leadProvider,
    ); // Export ALL leads, not just filtered ones
    final currentFilter = ref.watch(filterProvider);
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? const Color(0xFF1F1F1F)
            : AppColors.cBluePrimary,
        centerTitle: true,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  hintText: 'Search leads...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
              )
            : const Text(
                'CRM Dashboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() => _isSearching = false);
                  _searchController.clear();
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              )
            : IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  final current = ref.read(themeProvider);
                  ref
                      .read(themeProvider.notifier)
                      .state = current == ThemeMode.light
                      ? ThemeMode.dark
                      : ThemeMode.light;
                },
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => setState(() => _isSearching = true),
            ),

          // Filter Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            tooltip: 'Filter',
            initialValue: currentFilter ?? 'ALL',
            onSelected: (String value) {
              if (value == 'ALL') {
                ref.read(filterProvider.notifier).state = null;
                ref.read(leadProvider.notifier).loadLeads();
              } else {
                ref.read(filterProvider.notifier).state = value;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'ALL', child: Text('All Leads')),
              const PopupMenuDivider(),
              ...LeadStatus.values.map(
                (status) =>
                    PopupMenuItem(value: status.name, child: Text(status.name)),
              ),
            ],
          ),

          // ✦ NEW: "More Options" Menu for Export
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            tooltip: 'More Options',
            onSelected: (value) {
              if (value == 'export') {
                _exportLeads(allLeads);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download, color: Colors.grey),
                    SizedBox(width: 10),
                    Text('Export to JSON'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: leads.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No leads found.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: leads.length,
              itemBuilder: (context, index) {
                return LeadCard(lead: leads[index]);
              },
            ),
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddEditLeadScreen()),
            );
          },
        ),
      ),
    );
  }
}
